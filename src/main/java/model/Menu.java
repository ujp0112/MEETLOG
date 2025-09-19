package model;

public class Menu {
	private int id;
	private int restaurantId;
	private String name;
	private String price;
	private String description;
	private String image;
	private boolean isPopular;

	public Menu() {
	}

	public Menu(int restaurantId, String name, String price) {
		this.restaurantId = restaurantId;
		this.name = name;
		this.price = price;
	}

	// --- 모든 Getters and Setters ---
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public boolean isPopular() {
		return isPopular;
	}

	public void setPopular(boolean popular) {
		isPopular = popular;
	}
}