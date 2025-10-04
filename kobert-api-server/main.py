import torch
from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModel

# --- 1. 설정 및 모델 로딩 ---

# FastAPI 앱 초기화
app = FastAPI()

# 디바이스 설정: Apple Silicon(MPS) > CUDA > CPU 순으로 자동 선택
# Mac 사용자를 위해 MPS를 우선적으로 확인합니다.
print("PyTorch device checking...")
if torch.backends.mps.is_available():
    device = torch.device("mps")
    print("MPS(Apple Silicon GPU) is available.")
elif torch.cuda.is_available():
    device = torch.device("cuda")
    print("CUDA is available.")
else:
    device = torch.device("cpu")
    print("CPU will be used.")

# KoBERT 모델과 토크나이저 로드 (Hugging Face Hub 사용)
# 'skt/kobert-base-v1'은 원본 KoBERT를 개선한 버전입니다.
MODEL_NAME = 'skt/kobert-base-v1'
print(f"Loading model: {MODEL_NAME}...")
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
model = AutoModel.from_pretrained(MODEL_NAME).to(device)
print("Model loading complete.")


# --- 2. 입력/출력 데이터 모델 정의 ---

# API 요청 시 받을 데이터 형식 정의
class TextInput(BaseModel):
    text: str

# API 응답 시 보낼 데이터 형식 정의
class VectorResponse(BaseModel):
    text: str
    vector: list[float]


# --- 3. 텍스트 벡터 변환 함수 ---

def get_text_embedding(text: str) -> list[float]:
    """
    입력된 텍스트를 KoBERT 모델을 사용해 768차원의 벡터로 변환합니다.
    Mean Pooling 방식을 사용하여 문장 전체의 의미를 벡터에 담습니다.
    """
    # 텍스트 토크나이징
    inputs = tokenizer(
        text,
        return_tensors='pt', # PyTorch 텐서로 반환
        truncation=True,    # 문장이 길 경우 자르기
        padding=True,       # 패딩 추가
        max_length=128      # 최대 토큰 길이
    ).to(device)

    # 모델 추론 (gradient 계산 비활성화로 속도 향상)
    with torch.no_grad():
        outputs = model(**inputs)

    # Mean Pooling 수행
    # 마지막 hidden state의 토큰 임베딩들을 가져옴
    last_hidden_states = outputs.last_hidden_state
    # 패딩 토큰을 제외하고 평균을 계산하기 위해 attention mask를 사용
    attention_mask = inputs['attention_mask']
    mask_expanded = attention_mask.unsqueeze(-1).expand(last_hidden_states.size()).float()
    sum_embeddings = torch.sum(last_hidden_states * mask_expanded, 1)
    sum_mask = torch.clamp(mask_expanded.sum(1), min=1e-9)
    mean_pooled_vector = sum_embeddings / sum_mask

    # 결과를 CPU로 이동시켜 리스트로 변환
    return mean_pooled_vector.cpu().numpy().flatten().tolist()


# --- 4. API 엔드포인트 정의 ---

@app.post("/vectorize", response_model=VectorResponse)
def vectorize_text(item: TextInput):
    """
    POST 요청으로 텍스트를 받아 벡터로 변환하여 JSON 형태로 반환합니다.
    """
    # 텍스트 벡터 변환 함수 호출
    vector = get_text_embedding(item.text)
    
    return {"text": item.text, "vector": vector}

@app.get("/")
def read_root():
    return {"message": "KoBERT Vectorization API Server is running."}