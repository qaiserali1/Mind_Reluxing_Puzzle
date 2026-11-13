import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'storage_service.dart';

/// In-App Purchase service managing the one-time €4.99 premium unlock.
class IapService {
  static const String premiumId = 'rake_premium_unlock';

  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static ValueChanged<bool>? onPremiumStatusChanged;

  static bool _isAvailable = false;
  static ProductDetails? _premiumProduct;

  static bool get isAvailable => _isAvailable;
  static ProductDetails? get premiumProduct => _premiumProduct;

  /// Initializes the store connection and listens to purchase stream updates.
  static Future<void> initialize({ValueChanged<bool>? onStatusChanged}) async {
    onPremiumStatusChanged = onStatusChanged;
    try {
      _isAvailable = await _iap.isAvailable();
      if (!_isAvailable) return;

      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdated,
        onDone: () => _subscription?.cancel(),
        onError: (_) {},
      );

      // Query product details for €4.99 unlock
      final response = await _iap.queryProductDetails({premiumId});
      if (response.productDetails.isNotEmpty) {
        _premiumProduct = response.productDetails.first;
      }
    } catch (_) {}
  }

  /// Handles incoming purchase transactions.
  static void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Pending transaction
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Purchase failed
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.productID == premiumId) {
          _grantPremium();
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  static void _grantPremium() {
    StorageService.setPremiumUnlocked(true);
    onPremiumStatusChanged?.call(true);
  }

  /// Initiates non-consumable purchase flow.
  static Future<bool> buyPremium() async {
    try {
      if (!_isAvailable) {
        // For development / simulator environments: fallback simulation
        if (kDebugMode) {
          _grantPremium();
          return true;
        }
        return false;
      }

      final ProductDetails? product = _premiumProduct ??
          (await _iap.queryProductDetails({premiumId})).productDetails.firstOrNull;

      if (product == null) {
        if (kDebugMode) {
          _grantPremium();
          return true;
        }
        return false;
      }

      final purchaseParam = PurchaseParam(productDetails: product);
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (_) {
      return false;
    }
  }

  /// Restores existing non-consumable purchases.
  static Future<bool> restorePurchases() async {
    try {
      if (!_isAvailable) return false;
      await _iap.restorePurchases();
      return true;
    } catch (_) {
      return false;
    }
  }

  static void dispose() {
    _subscription?.cancel();
  }
}

