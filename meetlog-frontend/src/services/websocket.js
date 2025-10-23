import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

/**
 * WebSocket 클라이언트 서비스
 * 실시간 알림을 위한 STOMP over WebSocket
 */
class WebSocketService {
  constructor() {
    this.client = null;
    this.connected = false;
    this.subscriptions = [];
  }

  /**
   * WebSocket 연결
   * @param {number} userId - 사용자 ID
   * @param {function} onNotification - 알림 수신 콜백
   * @param {function} onUnreadCount - 읽지 않은 알림 수 수신 콜백
   */
  connect(userId, onNotification, onUnreadCount) {
    if (this.connected) {
      console.log('WebSocket already connected');
      return;
    }

    // SockJS를 통한 WebSocket 연결
    const socket = new SockJS(`${process.env.REACT_APP_API_URL || 'http://localhost:8080/api'}/ws`);

    this.client = new Client({
      webSocketFactory: () => socket,
      debug: (str) => {
        console.log('[STOMP Debug]', str);
      },
      reconnectDelay: 5000,
      heartbeatIncoming: 4000,
      heartbeatOutgoing: 4000,
      onConnect: () => {
        console.log('WebSocket connected');
        this.connected = true;

        // 개인 알림 구독
        const notificationSubscription = this.client.subscribe(
          `/user/${userId}/queue/notifications`,
          (message) => {
            try {
              const notification = JSON.parse(message.body);
              console.log('Received notification:', notification);
              if (onNotification) {
                onNotification(notification);
              }
            } catch (error) {
              console.error('Failed to parse notification:', error);
            }
          }
        );
        this.subscriptions.push(notificationSubscription);

        // 읽지 않은 알림 수 구독
        if (onUnreadCount) {
          const unreadCountSubscription = this.client.subscribe(
            `/user/${userId}/queue/unread-count`,
            (message) => {
              try {
                const count = parseInt(message.body);
                console.log('Received unread count:', count);
                onUnreadCount(count);
              } catch (error) {
                console.error('Failed to parse unread count:', error);
              }
            }
          );
          this.subscriptions.push(unreadCountSubscription);
        }

        // 공지사항 구독 (선택사항)
        const announcementSubscription = this.client.subscribe(
          '/topic/announcements',
          (message) => {
            console.log('Announcement:', message.body);
            // 공지사항 처리
          }
        );
        this.subscriptions.push(announcementSubscription);
      },
      onStompError: (frame) => {
        console.error('STOMP error:', frame);
        this.connected = false;
      },
      onWebSocketClose: () => {
        console.log('WebSocket connection closed');
        this.connected = false;
      },
      onWebSocketError: (error) => {
        console.error('WebSocket error:', error);
        this.connected = false;
      }
    });

    this.client.activate();
  }

  /**
   * WebSocket 연결 해제
   */
  disconnect() {
    if (this.client && this.connected) {
      // 모든 구독 해제
      this.subscriptions.forEach(subscription => {
        subscription.unsubscribe();
      });
      this.subscriptions = [];

      // 클라이언트 비활성화
      this.client.deactivate();
      this.connected = false;
      console.log('WebSocket disconnected');
    }
  }

  /**
   * 연결 상태 확인
   */
  isConnected() {
    return this.connected;
  }
}

// 싱글톤 인스턴스
const websocketService = new WebSocketService();

export default websocketService;
