//
//  CartData.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import Foundation

// MARK: - Cart Item Structure
struct GroceryCartItem {
    let id: String // Unique identifier for the cart item
    let item: GroceryMenuItem
    let selectedSize: SizeOption?
    var quantity: Int
    let parentId: String?
    let parentHeading: String?
    let subHeadingId: String?
    let subHeading: String?
    
    var totalPrice: Double {
        let sizePrice = selectedSize?.price ?? 0.0
        return sizePrice * Double(quantity)
    }
    
    // For identifying duplicates (same item + same size)
    var uniqueKey: String {
        return "\(item.id ?? "")_\(selectedSize?.name ?? "")_\(selectedSize?.size ?? "")"
    }
}

class GroceryCartData {
    static let shared = GroceryCartData()
    
    private(set) var cartItems: [GroceryCartItem] = []
    var tempStoreDetails: StoreDetails?
    var storeDetails: StoreDetails?
    var tempstoremenu: [ExpandedGroceryMenuCategory] = []
    var tempItemData: GroceryMenuItem?
    var itemData: GroceryMenuItem?
    var itemSizes: [Sizes] = []
    var dbname: String = ""
    var userAddress: UserAdd!
    var alternateNumber = ""
    var tips: Double = 0.0
    var giftNumber = ""
    var specialInstructionText = ""
    var rewardAmount = "0.0"
    var orderNumber = ""
    var supportNumber = ""
    private init() {}
    
    // MARK: - Cart Management Methods
    
    /// Add item to cart. If same item+size exists, increase quantity
    func addItem(_ item: GroceryMenuItem, 
                 size: SizeOption?, 
                 quantity: Int = 1,
                 parentId: String? = nil,
                 parentHeading: String? = nil,
                 subHeadingId: String? = nil,
                 subHeading: String? = nil) {
        
        let newItem = GroceryCartItem(
            id: UUID().uuidString,
            item: item,
            selectedSize: size,
            quantity: quantity,
            parentId: parentId,
            parentHeading: parentHeading,
            subHeadingId: subHeadingId,
            subHeading: subHeading
        )
        
        // Check if same item+size already exists
        if let existingIndex = cartItems.firstIndex(where: { $0.uniqueKey == newItem.uniqueKey }) {
            cartItems[existingIndex].quantity += quantity
        } else {
            cartItems.append(newItem)
        }
    }
    
    /// Update quantity for specific cart item
    func updateQuantity(for cartItemId: String, newQuantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.id == cartItemId }),
              newQuantity > 0 else { return }
        cartItems[index].quantity = newQuantity
    }
    
    /// Remove item from cart
    func removeItem(with cartItemId: String) {
        cartItems.removeAll { $0.id == cartItemId }
    }
    
    /// Clear entire cart
    func clearCart() {
        cartItems.removeAll()
        resetTempData()
    }
    
    /// Get total number of items in cart
    var totalItemCount: Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    /// Get total price of all items
    var totalPrice: Double {
        return cartItems.reduce(0.0) { $0 + $1.totalPrice }
    }
    
    /// Check if cart is empty
    var isEmpty: Bool {
        return cartItems.isEmpty
    }
    
    /// Get items grouped by parent category
    var itemsGroupedByParent: [String?: [GroceryCartItem]] {
        return Dictionary(grouping: cartItems) { $0.parentHeading }
    }
    
    /// Get subtotal (sum of all item prices)
    var subtotal: Double {
        return totalPrice
    }
    
    /// Get tax amount based on store's tax percentage
    var taxAmount: Double {
        let taxPercentage = storeDetails?.tax ?? 0.0
        return subtotal * (taxPercentage / 100.0)
    }
    
    /// Get convenience charge amount based on store's conv percentage
    var convAmount: Double {
        let convPercentage = storeDetails?.conv ?? 0.0
        return subtotal * (convPercentage / 100.0)
    }
    /// Get service charge amount 
    var serviceAmount: Double {
        
        guard let store = storeDetails,
              store.serviceFee == "Yes" else {
            return 0
        }
        
        let defaultCharge = store.scharged ?? 0.0
        let threshold = store.schargev ?? 0.0
        let overrideCharge = store.schargeo ?? 0.0
        
        // If subtotal crosses threshold → use override charge
        if subtotal >= threshold {
            return overrideCharge
        }
        
        return defaultCharge
    }
   
    /// Get delivery charge based on type (fixed $ or percentage %)
    var deliveryAmount: Double {
        guard let deliveryCharge = storeDetails?.deliveryCharge,
              let chargeType = storeDetails?.deliveryChargeType else {
            return 0.0
        }
        
        if chargeType.lowercased() == "%" {
            // Calculate as percentage of subtotal
            return subtotal * (deliveryCharge / 100.0)
        } else {
            // Direct fixed charge ($)
            return deliveryCharge
        }
    }
    
    /// Get total including tax, convenience charge, and delivery charge
    var total: Double {
        return subtotal + taxAmount + convAmount + deliveryAmount + serviceAmount
    }
    
    // MARK: - Utility Methods
    
    func resetTempData() {
        tempStoreDetails = nil
        storeDetails = nil
        tempstoremenu = []
        tempItemData = nil
        itemData = nil
        itemSizes = []
    }
    
    func refreshCartData() {
        // Implement any refresh logic if needed
        // For example, recalculate prices, check availability, etc.
    }
    
    // MARK: - Size and Topping Helpers (existing methods)
    
    func getAllSizes(menu: DisplaySection, item: MenuItem, isCatering: Bool, menuType: String) -> [Sizes] {
        // Existing implementation
        return []
    }
    
    func getMenuType(selectedMenuType: MenuType) -> String {
        // Existing implementation
        return ""
    }
    
    func roundValue2Digit(value: Float) -> String {
        return String(format: "%.2f", value)
    }
}
