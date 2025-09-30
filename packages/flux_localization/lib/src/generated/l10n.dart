// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `See All`
  String get seeAll {
    return Intl.message('See All', name: 'seeAll', desc: '', args: []);
  }

  /// `Featured Products`
  String get featureProducts {
    return Intl.message(
      'Featured Products',
      name: 'featureProducts',
      desc: '',
      args: [],
    );
  }

  /// `Gear Collections`
  String get bagsCollections {
    return Intl.message(
      'Gear Collections',
      name: 'bagsCollections',
      desc: '',
      args: [],
    );
  }

  /// `Women's Collections`
  String get womanCollections {
    return Intl.message(
      'Women\'s Collections',
      name: 'womanCollections',
      desc: '',
      args: [],
    );
  }

  /// `Men's Collections`
  String get manCollections {
    return Intl.message(
      'Men\'s Collections',
      name: 'manCollections',
      desc: '',
      args: [],
    );
  }

  /// `Buy Now`
  String get buyNow {
    return Intl.message('Buy Now', name: 'buyNow', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Reviews`
  String get readReviews {
    return Intl.message('Reviews', name: 'readReviews', desc: '', args: []);
  }

  /// `Additional Information`
  String get additionalInformation {
    return Intl.message(
      'Additional Information',
      name: 'additionalInformation',
      desc: '',
      args: [],
    );
  }

  /// `No Reviews`
  String get noReviews {
    return Intl.message('No Reviews', name: 'noReviews', desc: '', args: []);
  }

  /// `Product has been added`
  String get productAdded {
    return Intl.message(
      'Product has been added',
      name: 'productAdded',
      desc: '',
      args: [],
    );
  }

  /// `You might also like`
  String get youMightAlsoLike {
    return Intl.message(
      'You might also like',
      name: 'youMightAlsoLike',
      desc: '',
      args: [],
    );
  }

  /// `Select size`
  String get selectTheSize {
    return Intl.message(
      'Select size',
      name: 'selectTheSize',
      desc: '',
      args: [],
    );
  }

  /// `Select color`
  String get selectTheColor {
    return Intl.message(
      'Select color',
      name: 'selectTheColor',
      desc: '',
      args: [],
    );
  }

  /// `Select quantity`
  String get selectTheQuantity {
    return Intl.message(
      'Select quantity',
      name: 'selectTheQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Select file`
  String get selectTheFile {
    return Intl.message(
      'Select file',
      name: 'selectTheFile',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message('Size', name: 'size', desc: '', args: []);
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `My Cart`
  String get myCart {
    return Intl.message('My Cart', name: 'myCart', desc: '', args: []);
  }

  /// `Save to Wishlist`
  String get saveToWishList {
    return Intl.message(
      'Save to Wishlist',
      name: 'saveToWishList',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Clear Cart`
  String get clearCart {
    return Intl.message('Clear Cart', name: 'clearCart', desc: '', args: []);
  }

  /// `My Wishlist`
  String get myWishList {
    return Intl.message('My Wishlist', name: 'myWishList', desc: '', args: []);
  }

  /// `My Orders`
  String get myOrder {
    return Intl.message('My Orders', name: 'myOrder', desc: '', args: []);
  }

  /// `Your bag is empty`
  String get yourBagIsEmpty {
    return Intl.message(
      'Your bag is empty',
      name: 'yourBagIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Empty cart`
  String get emptyCart {
    return Intl.message('Empty cart', name: 'emptyCart', desc: '', args: []);
  }

  /// `Looks like you haven't added any items to your bag yet. Start shopping to fill it up.`
  String get emptyCartSubtitle {
    return Intl.message(
      'Looks like you haven\'t added any items to your bag yet. Start shopping to fill it up.',
      name: 'emptyCartSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Your cart is feeling a bit light. \n\nReady to shop for something fabulous?`
  String get emptyCartSubtitle02 {
    return Intl.message(
      'Oops! Your cart is feeling a bit light. \n\nReady to shop for something fabulous?',
      name: 'emptyCartSubtitle02',
      desc: '',
      args: [],
    );
  }

  /// `Start Shopping`
  String get startShopping {
    return Intl.message(
      'Start Shopping',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `Add to Wishlist`
  String get addToWishlist {
    return Intl.message(
      'Add to Wishlist',
      name: 'addToWishlist',
      desc: '',
      args: [],
    );
  }

  /// `No favorites yet`
  String get noFavoritesYet {
    return Intl.message(
      'No favorites yet',
      name: 'noFavoritesYet',
      desc: '',
      args: [],
    );
  }

  /// `Empty wishlist`
  String get emptyWishlist {
    return Intl.message(
      'Empty wishlist',
      name: 'emptyWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Tap any heart next to a product to add it to your favorites. We'll save them for you here!`
  String get emptyWishlistSubtitle {
    return Intl.message(
      'Tap any heart next to a product to add it to your favorites. We\'ll save them for you here!',
      name: 'emptyWishlistSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Your wishlist is currently empty.\nStart adding products now!`
  String get emptyWishlistSubtitle02 {
    return Intl.message(
      'Your wishlist is currently empty.\nStart adding products now!',
      name: 'emptyWishlistSubtitle02',
      desc: '',
      args: [],
    );
  }

  /// `Search for items`
  String get searchForItems {
    return Intl.message(
      'Search for items',
      name: 'searchForItems',
      desc: '',
      args: [],
    );
  }

  /// `Shipping`
  String get shipping {
    return Intl.message('Shipping', name: 'shipping', desc: '', args: []);
  }

  /// `Shipping Fee`
  String get shippingFee {
    return Intl.message(
      'Shipping Fee',
      name: 'shippingFee',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Review`
  String get review {
    return Intl.message('Review', name: 'review', desc: '', args: []);
  }

  /// `Product Overview`
  String get productOverview {
    return Intl.message(
      'Product Overview',
      name: 'productOverview',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `State/Province`
  String get stateProvince {
    return Intl.message(
      'State/Province',
      name: 'stateProvince',
      desc: '',
      args: [],
    );
  }

  /// `ZIP Code`
  String get zipCode {
    return Intl.message('ZIP Code', name: 'zipCode', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Street Name`
  String get streetName {
    return Intl.message('Street Name', name: 'streetName', desc: '', args: []);
  }

  /// `Shipping Method`
  String get shippingMethod {
    return Intl.message(
      'Shipping Method',
      name: 'shippingMethod',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Shipping`
  String get continueToShipping {
    return Intl.message(
      'Continue to Shipping',
      name: 'continueToShipping',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Review`
  String get continueToReview {
    return Intl.message(
      'Continue to Review',
      name: 'continueToReview',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Payment`
  String get continueToPayment {
    return Intl.message(
      'Continue to Payment',
      name: 'continueToPayment',
      desc: '',
      args: [],
    );
  }

  /// `Back to Address`
  String get goBackToAddress {
    return Intl.message(
      'Back to Address',
      name: 'goBackToAddress',
      desc: '',
      args: [],
    );
  }

  /// `Back to Shipping`
  String get goBackToShipping {
    return Intl.message(
      'Back to Shipping',
      name: 'goBackToShipping',
      desc: '',
      args: [],
    );
  }

  /// `Back to Review`
  String get goBackToReview {
    return Intl.message(
      'Back to Review',
      name: 'goBackToReview',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Shipping Address`
  String get shippingAddress {
    return Intl.message(
      'Shipping Address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetail {
    return Intl.message(
      'Order Details',
      name: 'orderDetail',
      desc: '',
      args: [],
    );
  }

  /// `View Order`
  String get viewOrder {
    return Intl.message('View Order', name: 'viewOrder', desc: '', args: []);
  }

  /// `Continue Shopping`
  String get continueShopping {
    return Intl.message(
      'Continue Shopping',
      name: 'continueShopping',
      desc: '',
      args: [],
    );
  }

  /// `Your Order is Confirmed!`
  String get yourOrderIsConfirmed {
    return Intl.message(
      'Your Order is Confirmed!',
      name: 'yourOrderIsConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for your order. We're quickly processing it and will send you a confirmation email shortly.`
  String get subTitleOrderConfirmed {
    return Intl.message(
      'Thanks for your order. We\'re quickly processing it and will send you a confirmation email shortly.',
      name: 'subTitleOrderConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Payment Methods`
  String get paymentMethods {
    return Intl.message(
      'Payment Methods',
      name: 'paymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `Choose your payment method`
  String get chooseYourPaymentMethod {
    return Intl.message(
      'Choose your payment method',
      name: 'chooseYourPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Place Order`
  String get placeMyOrder {
    return Intl.message(
      'Place Order',
      name: 'placeMyOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order Placed!`
  String get itsOrdered {
    return Intl.message(
      'Order Placed!',
      name: 'itsOrdered',
      desc: '',
      args: [],
    );
  }

  /// `Order No.`
  String get orderNo {
    return Intl.message('Order No.', name: 'orderNo', desc: '', args: []);
  }

  /// `Show All My Orders`
  String get showAllMyOrdered {
    return Intl.message(
      'Show All My Orders',
      name: 'showAllMyOrdered',
      desc: '',
      args: [],
    );
  }

  /// `Back to Shop`
  String get backToShop {
    return Intl.message('Back to Shop', name: 'backToShop', desc: '', args: []);
  }

  /// `First name is required`
  String get firstNameIsRequired {
    return Intl.message(
      'First name is required',
      name: 'firstNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Last name is required`
  String get lastNameIsRequired {
    return Intl.message(
      'Last name is required',
      name: 'lastNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Street name is required`
  String get streetIsRequired {
    return Intl.message(
      'Street name is required',
      name: 'streetIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `City is required`
  String get cityIsRequired {
    return Intl.message(
      'City is required',
      name: 'cityIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `State is required`
  String get stateIsRequired {
    return Intl.message(
      'State is required',
      name: 'stateIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Country is required`
  String get countryIsRequired {
    return Intl.message(
      'Country is required',
      name: 'countryIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneIsRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailIsRequired {
    return Intl.message(
      'Email is required',
      name: 'emailIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `ZIP code is required`
  String get zipCodeIsRequired {
    return Intl.message(
      'ZIP code is required',
      name: 'zipCodeIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `No Orders`
  String get noOrders {
    return Intl.message('No Orders', name: 'noOrders', desc: '', args: []);
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message('Order Date', name: 'orderDate', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get orderHistory {
    return Intl.message(
      'Order History',
      name: 'orderHistory',
      desc: '',
      args: [],
    );
  }

  /// `Refund Request`
  String get refundRequest {
    return Intl.message(
      'Refund Request',
      name: 'refundRequest',
      desc: '',
      args: [],
    );
  }

  /// `Recent Searches`
  String get recentSearches {
    return Intl.message(
      'Recent Searches',
      name: 'recentSearches',
      desc: '',
      args: [],
    );
  }

  /// `Recent`
  String get recent {
    return Intl.message('Recent', name: 'recent', desc: '', args: []);
  }

  /// `By Price`
  String get byPrice {
    return Intl.message('By Price', name: 'byPrice', desc: '', args: []);
  }

  /// `By Category`
  String get byCategory {
    return Intl.message('By Category', name: 'byCategory', desc: '', args: []);
  }

  /// `By Brand`
  String get byBrand {
    return Intl.message('By Brand', name: 'byBrand', desc: '', args: []);
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `General Settings`
  String get generalSetting {
    return Intl.message(
      'General Settings',
      name: 'generalSetting',
      desc: '',
      args: [],
    );
  }

  /// `Get Notifications`
  String get getNotification {
    return Intl.message(
      'Get Notifications',
      name: 'getNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notification Messages`
  String get listMessages {
    return Intl.message(
      'Notification Messages',
      name: 'listMessages',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get language {
    return Intl.message('Languages', name: 'language', desc: '', args: []);
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message('Dark Theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `Rate the App`
  String get rateTheApp {
    return Intl.message('Rate the App', name: 'rateTheApp', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `items`
  String get items {
    return Intl.message('items', name: 'items', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Shop`
  String get shop {
    return Intl.message('Shop', name: 'shop', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Blog`
  String get blog {
    return Intl.message('Blog', name: 'blog', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Sign in with email`
  String get signInWithEmail {
    return Intl.message(
      'Sign in with email',
      name: 'signInWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Please fill in all required fields`
  String get pleaseInput {
    return Intl.message(
      'Please fill in all required fields',
      name: 'pleaseInput',
      desc: '',
      args: [],
    );
  }

  /// `Search Address`
  String get searchingAddress {
    return Intl.message(
      'Search Address',
      name: 'searchingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Out of Stock`
  String get outOfStock {
    return Intl.message('Out of Stock', name: 'outOfStock', desc: '', args: []);
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message('Unavailable', name: 'unavailable', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `No Products`
  String get noProduct {
    return Intl.message('No Products', name: 'noProduct', desc: '', args: []);
  }

  /// `We found {length} products`
  String weFoundProducts(Object length) {
    return Intl.message(
      'We found $length products',
      name: 'weFoundProducts',
      desc: '',
      args: [length],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Your Recent Views`
  String get recentView {
    return Intl.message(
      'Your Recent Views',
      name: 'recentView',
      desc: '',
      args: [],
    );
  }

  /// `Recently Viewed`
  String get recentlyViewed {
    return Intl.message(
      'Recently Viewed',
      name: 'recentlyViewed',
      desc: '',
      args: [],
    );
  }

  /// `In Stock`
  String get inStock {
    return Intl.message('In Stock', name: 'inStock', desc: '', args: []);
  }

  /// `Tracking number is`
  String get trackingNumberIs {
    return Intl.message(
      'Tracking number is',
      name: 'trackingNumberIs',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Availability:`
  String get availabilityProduct {
    return Intl.message(
      'Availability:',
      name: 'availabilityProduct',
      desc: '',
      args: [],
    );
  }

  /// `Tracking Page`
  String get trackingPage {
    return Intl.message(
      'Tracking Page',
      name: 'trackingPage',
      desc: '',
      args: [],
    );
  }

  /// `My Points`
  String get myPoints {
    return Intl.message('My Points', name: 'myPoints', desc: '', args: []);
  }

  /// `You have {point} points`
  String youHavePoints(Object point) {
    return Intl.message(
      'You have $point points',
      name: 'youHavePoints',
      desc: '',
      args: [point],
    );
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Point`
  String get point {
    return Intl.message('Point', name: 'point', desc: '', args: []);
  }

  /// `Order Notes`
  String get orderNotes {
    return Intl.message('Order Notes', name: 'orderNotes', desc: '', args: []);
  }

  /// `Please rate before you send your comment`
  String get ratingFirst {
    return Intl.message(
      'Please rate before you send your comment',
      name: 'ratingFirst',
      desc: '',
      args: [],
    );
  }

  /// `Please write your comment`
  String get commentFirst {
    return Intl.message(
      'Please write your comment',
      name: 'commentFirst',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment`
  String get writeComment {
    return Intl.message(
      'Write your comment',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Processing...`
  String get processing {
    return Intl.message(
      'Processing...',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Your Rating`
  String get productRating {
    return Intl.message(
      'Your Rating',
      name: 'productRating',
      desc: '',
      args: [],
    );
  }

  /// `Layouts`
  String get layout {
    return Intl.message('Layouts', name: 'layout', desc: '', args: []);
  }

  /// `Select Address`
  String get selectAddress {
    return Intl.message(
      'Select Address',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get saveAddress {
    return Intl.message(
      'Save Address',
      name: 'saveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your search in the field`
  String get searchInput {
    return Intl.message(
      'Please enter your search in the field',
      name: 'searchInput',
      desc: '',
      args: [],
    );
  }

  /// `Total Tax`
  String get totalTax {
    return Intl.message('Total Tax', name: 'totalTax', desc: '', args: []);
  }

  /// `Invalid SMS Verification Code`
  String get invalidSMSCode {
    return Intl.message(
      'Invalid SMS Verification Code',
      name: 'invalidSMSCode',
      desc: '',
      args: [],
    );
  }

  /// `Get Code`
  String get sendSMSCode {
    return Intl.message('Get Code', name: 'sendSMSCode', desc: '', args: []);
  }

  /// `Verify`
  String get verifySMSCode {
    return Intl.message('Verify', name: 'verifySMSCode', desc: '', args: []);
  }

  /// `Show Gallery`
  String get showGallery {
    return Intl.message(
      'Show Gallery',
      name: 'showGallery',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `I want to create an account`
  String get iwantToCreateAccount {
    return Intl.message(
      'I want to create an account',
      name: 'iwantToCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get loginToYourAccount {
    return Intl.message(
      'Login to your account',
      name: 'loginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAnAccount {
    return Intl.message(
      'Create an account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Code`
  String get couponCode {
    return Intl.message('Coupon Code', name: 'couponCode', desc: '', args: []);
  }

  /// `Select Voucher`
  String get selectVoucher {
    return Intl.message(
      'Select Voucher',
      name: 'selectVoucher',
      desc: '',
      args: [],
    );
  }

  /// `Please enter or select a voucher for your order.`
  String get descriptionEnterVoucher {
    return Intl.message(
      'Please enter or select a voucher for your order.',
      name: 'descriptionEnterVoucher',
      desc: '',
      args: [],
    );
  }

  /// `Enter voucher code`
  String get enterVoucherCode {
    return Intl.message(
      'Enter voucher code',
      name: 'enterVoucherCode',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Congratulations! Coupon code applied successfully`
  String get couponMsgSuccess {
    return Intl.message(
      'Congratulations! Coupon code applied successfully',
      name: 'couponMsgSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Address saved successfully`
  String get saveAddressSuccess {
    return Intl.message(
      'Address saved successfully',
      name: 'saveAddressSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Your Note`
  String get yourNote {
    return Intl.message('Your Note', name: 'yourNote', desc: '', args: []);
  }

  /// `Write your note`
  String get writeYourNote {
    return Intl.message(
      'Write your note',
      name: 'writeYourNote',
      desc: '',
      args: [],
    );
  }

  /// `You've successfully placed your order`
  String get orderSuccessTitle1 {
    return Intl.message(
      'You\'ve successfully placed your order',
      name: 'orderSuccessTitle1',
      desc: '',
      args: [],
    );
  }

  /// `You can check the status of your order using our delivery status feature. You will receive an order confirmation email with details of your order and a link to track its progress.`
  String get orderSuccessMsg1 {
    return Intl.message(
      'You can check the status of your order using our delivery status feature. You will receive an order confirmation email with details of your order and a link to track its progress.',
      name: 'orderSuccessMsg1',
      desc: '',
      args: [],
    );
  }

  /// `Your Account`
  String get orderSuccessTitle2 {
    return Intl.message(
      'Your Account',
      name: 'orderSuccessTitle2',
      desc: '',
      args: [],
    );
  }

  /// `You can log into your account using your email and password. On your account you can edit your profile data, check transaction history, and edit newsletter subscription.`
  String get orderSuccessMsg2 {
    return Intl.message(
      'You can log into your account using your email and password. On your account you can edit your profile data, check transaction history, and edit newsletter subscription.',
      name: 'orderSuccessMsg2',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Currencies`
  String get currencies {
    return Intl.message('Currencies', name: 'currencies', desc: '', args: []);
  }

  /// `{percent}% Off`
  String sale(Object percent) {
    return Intl.message(
      '$percent% Off',
      name: 'sale',
      desc: '',
      args: [percent],
    );
  }

  /// `Update Profile`
  String get updateUserInfor {
    return Intl.message(
      'Update Profile',
      name: 'updateUserInfor',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Display Name`
  String get displayName {
    return Intl.message(
      'Display Name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Nice Name`
  String get niceName {
    return Intl.message('Nice Name', name: 'niceName', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message('Vietnamese', name: 'vietnamese', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Spanish`
  String get spanish {
    return Intl.message('Spanish', name: 'spanish', desc: '', args: []);
  }

  /// `Chinese`
  String get chinese {
    return Intl.message('Chinese', name: 'chinese', desc: '', args: []);
  }

  /// `Japanese`
  String get japanese {
    return Intl.message('Japanese', name: 'japanese', desc: '', args: []);
  }

  /// `Language updated successfully`
  String get languageSuccess {
    return Intl.message(
      'Language updated successfully',
      name: 'languageSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Privacy and Terms`
  String get agreeWithPrivacy {
    return Intl.message(
      'Privacy and Terms',
      name: 'agreeWithPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Privacy and Terms`
  String get privacyAndTerm {
    return Intl.message(
      'Privacy and Terms',
      name: 'privacyAndTerm',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the`
  String get iAgree {
    return Intl.message('I agree to the', name: 'iAgree', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Stores`
  String get stores {
    return Intl.message('Stores', name: 'stores', desc: '', args: []);
  }

  /// `Visit Store`
  String get visitStore {
    return Intl.message('Visit Store', name: 'visitStore', desc: '', args: []);
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message('Sale Price', name: 'salePrice', desc: '', args: []);
  }

  /// `Regular Price`
  String get regularPrice {
    return Intl.message(
      'Regular Price',
      name: 'regularPrice',
      desc: '',
      args: [],
    );
  }

  /// `Image Gallery`
  String get imageGallery {
    return Intl.message(
      'Image Gallery',
      name: 'imageGallery',
      desc: '',
      args: [],
    );
  }

  /// `Adding your image`
  String get addingYourImage {
    return Intl.message(
      'Adding your image',
      name: 'addingYourImage',
      desc: '',
      args: [],
    );
  }

  /// `Post Product`
  String get postProduct {
    return Intl.message(
      'Post Product',
      name: 'postProduct',
      desc: '',
      args: [],
    );
  }

  /// `Create Product`
  String get createProduct {
    return Intl.message(
      'Create Product',
      name: 'createProduct',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for image to load`
  String get waitForLoad {
    return Intl.message(
      'Waiting for image to load',
      name: 'waitForLoad',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for product to post`
  String get waitForPost {
    return Intl.message(
      'Waiting for product to post',
      name: 'waitForPost',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productName {
    return Intl.message(
      'Product Name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Product Type`
  String get productType {
    return Intl.message(
      'Product Type',
      name: 'productType',
      desc: '',
      args: [],
    );
  }

  /// `Conversations`
  String get conversations {
    return Intl.message(
      'Conversations',
      name: 'conversations',
      desc: '',
      args: [],
    );
  }

  /// `My Products`
  String get myProducts {
    return Intl.message('My Products', name: 'myProducts', desc: '', args: []);
  }

  /// `You don't have any products. Try creating one!`
  String get myProductsEmpty {
    return Intl.message(
      'You don\'t have any products. Try creating one!',
      name: 'myProductsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Added to cart successfully`
  String get addToCartSuccessfully {
    return Intl.message(
      'Added to cart successfully',
      name: 'addToCartSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Pull to load more`
  String get pullToLoadMore {
    return Intl.message(
      'Pull to load more',
      name: 'pullToLoadMore',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed!`
  String get loadFail {
    return Intl.message('Load Failed!', name: 'loadFail', desc: '', args: []);
  }

  /// `Release to load more`
  String get releaseToLoadMore {
    return Intl.message(
      'Release to load more',
      name: 'releaseToLoadMore',
      desc: '',
      args: [],
    );
  }

  /// `View More`
  String get viewMore {
    return Intl.message('View More', name: 'viewMore', desc: '', args: []);
  }

  /// `No more data`
  String get noData {
    return Intl.message('No more data', name: 'noData', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Tags`
  String get tags {
    return Intl.message('Tags', name: 'tags', desc: '', args: []);
  }

  /// `Attributes`
  String get attributes {
    return Intl.message('Attributes', name: 'attributes', desc: '', args: []);
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your Password`
  String get resetYourPassword {
    return Intl.message(
      'Reset Your Password',
      name: 'resetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your username or email`
  String get yourUsernameEmail {
    return Intl.message(
      'Your username or email',
      name: 'yourUsernameEmail',
      desc: '',
      args: [],
    );
  }

  /// `Get password link`
  String get getPasswordLink {
    return Intl.message(
      'Get password link',
      name: 'getPasswordLink',
      desc: '',
      args: [],
    );
  }

  /// `Check your email for confirmation link`
  String get checkConfirmLink {
    return Intl.message(
      'Check your email for confirmation link',
      name: 'checkConfirmLink',
      desc: '',
      args: [],
    );
  }

  /// `Username/Email is empty`
  String get emptyUsername {
    return Intl.message(
      'Username/Email is empty',
      name: 'emptyUsername',
      desc: '',
      args: [],
    );
  }

  /// `Romanian`
  String get romanian {
    return Intl.message('Romanian', name: 'romanian', desc: '', args: []);
  }

  /// `Turkish`
  String get turkish {
    return Intl.message('Turkish', name: 'turkish', desc: '', args: []);
  }

  /// `Italian`
  String get italian {
    return Intl.message('Italian', name: 'italian', desc: '', args: []);
  }

  /// `Indonesian`
  String get indonesian {
    return Intl.message('Indonesian', name: 'indonesian', desc: '', args: []);
  }

  /// `German`
  String get german {
    return Intl.message('German', name: 'german', desc: '', args: []);
  }

  /// `Your coupon code is invalid`
  String get couponInvalid {
    return Intl.message(
      'Your coupon code is invalid',
      name: 'couponInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Featured`
  String get featured {
    return Intl.message('Featured', name: 'featured', desc: '', args: []);
  }

  /// `On Sale`
  String get onSale {
    return Intl.message('On Sale', name: 'onSale', desc: '', args: []);
  }

  /// `Please check your internet connection!`
  String get pleaseCheckInternet {
    return Intl.message(
      'Please check your internet connection!',
      name: 'pleaseCheckInternet',
      desc: '',
      args: [],
    );
  }

  /// `Cannot launch this app. Make sure your settings in config.dart are correct`
  String get canNotLaunch {
    return Intl.message(
      'Cannot launch this app. Make sure your settings in config.dart are correct',
      name: 'canNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Billing Address`
  String get billingAddress {
    return Intl.message(
      'Billing Address',
      name: 'billingAddress',
      desc: '',
      args: [],
    );
  }

  /// `No addresses have been saved yet`
  String get noAddressHaveBeenSaved {
    return Intl.message(
      'No addresses have been saved yet',
      name: 'noAddressHaveBeenSaved',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit the app?`
  String get doYouWantToExitApp {
    return Intl.message(
      'Do you want to exit the app?',
      name: 'doYouWantToExitApp',
      desc: '',
      args: [],
    );
  }

  /// `Shopping cart, {totalCartQuantity} items`
  String shoppingCartItems(Object totalCartQuantity) {
    return Intl.message(
      'Shopping cart, $totalCartQuantity items',
      name: 'shoppingCartItems',
      desc: '',
      args: [totalCartQuantity],
    );
  }

  /// `On Hold`
  String get orderStatusOnHold {
    return Intl.message(
      'On Hold',
      name: 'orderStatusOnHold',
      desc: '',
      args: [],
    );
  }

  /// `Pending Payment`
  String get orderStatusPendingPayment {
    return Intl.message(
      'Pending Payment',
      name: 'orderStatusPendingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get orderStatusFailed {
    return Intl.message(
      'Failed',
      name: 'orderStatusFailed',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get orderStatusProcessing {
    return Intl.message(
      'Processing',
      name: 'orderStatusProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get orderStatusPending {
    return Intl.message(
      'Pending',
      name: 'orderStatusPending',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get orderStatusCompleted {
    return Intl.message(
      'Completed',
      name: 'orderStatusCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get orderStatusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'orderStatusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Refunded`
  String get orderStatusRefunded {
    return Intl.message(
      'Refunded',
      name: 'orderStatusRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your code`
  String get pleaseFillCode {
    return Intl.message(
      'Please enter your code',
      name: 'pleaseFillCode',
      desc: '',
      args: [],
    );
  }

  /// `Warning: {message}`
  String warning(Object message) {
    return Intl.message(
      'Warning: $message',
      name: 'warning',
      desc: '',
      args: [message],
    );
  }

  /// `{itemCount} items`
  String nItems(Object itemCount) {
    return Intl.message(
      '$itemCount items',
      name: 'nItems',
      desc: '',
      args: [itemCount],
    );
  }

  /// `No Data`
  String get dataEmpty {
    return Intl.message('No Data', name: 'dataEmpty', desc: '', args: []);
  }

  /// `Address exists in your local storage`
  String get yourAddressExistYourLocal {
    return Intl.message(
      'Address exists in your local storage',
      name: 'yourAddressExistYourLocal',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `The address has been saved to your local storage`
  String get yourAddressHasBeenSaved {
    return Intl.message(
      'The address has been saved to your local storage',
      name: 'yourAddressHasBeenSaved',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `This platform does not support webview`
  String get thisPlatformNotSupportWebview {
    return Intl.message(
      'This platform does not support webview',
      name: 'thisPlatformNotSupportWebview',
      desc: '',
      args: [],
    );
  }

  /// `No back history item`
  String get noBackHistoryItem {
    return Intl.message(
      'No back history item',
      name: 'noBackHistoryItem',
      desc: '',
      args: [],
    );
  }

  /// `No forward history item`
  String get noForwardHistoryItem {
    return Intl.message(
      'No forward history item',
      name: 'noForwardHistoryItem',
      desc: '',
      args: [],
    );
  }

  /// `Date Booking`
  String get dateBooking {
    return Intl.message(
      'Date Booking',
      name: 'dateBooking',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Added Successfully`
  String get addedSuccessfully {
    return Intl.message(
      'Added Successfully',
      name: 'addedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Not Found`
  String get notFound {
    return Intl.message('Not Found', name: 'notFound', desc: '', args: []);
  }

  /// `Error: {message}`
  String errorMsg(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'errorMsg',
      desc: '',
      args: [message],
    );
  }

  /// `Go back to home page`
  String get goBackHomePage {
    return Intl.message(
      'Go back to home page',
      name: 'goBackHomePage',
      desc: '',
      args: [],
    );
  }

  /// `Oops, the blog no longer exists`
  String get noBlog {
    return Intl.message(
      'Oops, the blog no longer exists',
      name: 'noBlog',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get prev {
    return Intl.message('Previous', name: 'prev', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `Download App`
  String get downloadApp {
    return Intl.message(
      'Download App',
      name: 'downloadApp',
      desc: '',
      args: [],
    );
  }

  /// `{day} days ago`
  String daysAgo(Object day) {
    return Intl.message(
      '$day days ago',
      name: 'daysAgo',
      desc: '',
      args: [day],
    );
  }

  /// `{hour} hours ago`
  String hoursAgo(Object hour) {
    return Intl.message(
      '$hour hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [hour],
    );
  }

  /// `{minute} minutes ago`
  String minutesAgo(Object minute) {
    return Intl.message(
      '$minute minutes ago',
      name: 'minutesAgo',
      desc: '',
      args: [minute],
    );
  }

  /// `{second} seconds ago`
  String secondsAgo(Object second) {
    return Intl.message(
      '$second seconds ago',
      name: 'secondsAgo',
      desc: '',
      args: [second],
    );
  }

  /// `Rate this app`
  String get rateThisApp {
    return Intl.message(
      'Rate this app',
      name: 'rateThisApp',
      desc: '',
      args: [],
    );
  }

  /// `If you like this app, please take a moment to review it!\nIt really helps us and shouldn't take more than a minute.`
  String get rateThisAppDescription {
    return Intl.message(
      'If you like this app, please take a moment to review it!\nIt really helps us and shouldn\'t take more than a minute.',
      name: 'rateThisAppDescription',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get rate {
    return Intl.message('Rate', name: 'rate', desc: '', args: []);
  }

  /// `No thanks`
  String get noThanks {
    return Intl.message('No thanks', name: 'noThanks', desc: '', args: []);
  }

  /// `Maybe Later`
  String get maybeLater {
    return Intl.message('Maybe Later', name: 'maybeLater', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Phone Number Verification`
  String get phoneNumberVerification {
    return Intl.message(
      'Phone Number Verification',
      name: 'phoneNumberVerification',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent to`
  String get enterSentCode {
    return Intl.message(
      'Enter the code sent to',
      name: 'enterSentCode',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all cells properly`
  String get pleaseFillUpAllCellsProperly {
    return Intl.message(
      'Please fill in all cells properly',
      name: 'pleaseFillUpAllCellsProperly',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get didntReceiveCode {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didntReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `Please fill in all fields`
  String get pleaseInputFillAllFields {
    return Intl.message(
      'Please fill in all fields',
      name: 'pleaseInputFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Please agree to our terms`
  String get pleaseAgreeTerms {
    return Intl.message(
      'Please agree to our terms',
      name: 'pleaseAgreeTerms',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get url {
    return Intl.message('URL', name: 'url', desc: '', args: []);
  }

  /// `Nearby Places`
  String get nearbyPlaces {
    return Intl.message(
      'Nearby Places',
      name: 'nearbyPlaces',
      desc: '',
      args: [],
    );
  }

  /// `No Results Found`
  String get noResultFound {
    return Intl.message(
      'No Results Found',
      name: 'noResultFound',
      desc: '',
      args: [],
    );
  }

  /// `No suggestions found`
  String get noSuggestionSearch {
    return Intl.message(
      'No suggestions found',
      name: 'noSuggestionSearch',
      desc: '',
      args: [],
    );
  }

  /// `Search Place`
  String get searchPlace {
    return Intl.message(
      'Search Place',
      name: 'searchPlace',
      desc: '',
      args: [],
    );
  }

  /// `{keyword} ({count} items)`
  String searchResultItems(Object keyword, Object count) {
    return Intl.message(
      '$keyword ($count items)',
      name: 'searchResultItems',
      desc: '',
      args: [keyword, count],
    );
  }

  /// `{keyword} ({count} item)`
  String searchResultItem(Object keyword, Object count) {
    return Intl.message(
      '$keyword ($count item)',
      name: 'searchResultItem',
      desc: '',
      args: [keyword, count],
    );
  }

  /// `Search results for: '{keyword}'`
  String searchResultFor(Object keyword) {
    return Intl.message(
      'Search results for: \'$keyword\'',
      name: 'searchResultFor',
      desc: '',
      args: [keyword],
    );
  }

  /// `Tap to select this location`
  String get tapSelectLocation {
    return Intl.message(
      'Tap to select this location',
      name: 'tapSelectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get brazil {
    return Intl.message('Portuguese', name: 'brazil', desc: '', args: []);
  }

  /// `On backorder`
  String get backOrder {
    return Intl.message('On backorder', name: 'backOrder', desc: '', args: []);
  }

  /// `French`
  String get french {
    return Intl.message('French', name: 'french', desc: '', args: []);
  }

  /// `There is an issue with the app during the data request. Please contact admin to fix the issues: {message}`
  String loginErrorServiceProvider(Object message) {
    return Intl.message(
      'There is an issue with the app during the data request. Please contact admin to fix the issues: $message',
      name: 'loginErrorServiceProvider',
      desc: '',
      args: [message],
    );
  }

  /// `Login cancelled`
  String get loginCanceled {
    return Intl.message(
      'Login cancelled',
      name: 'loginCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Oops, this page no longer exists!`
  String get noPost {
    return Intl.message(
      'Oops, this page no longer exists!',
      name: 'noPost',
      desc: '',
      args: [],
    );
  }

  /// `Minimum quantity is`
  String get minimumQuantityIs {
    return Intl.message(
      'Minimum quantity is',
      name: 'minimumQuantityIs',
      desc: '',
      args: [],
    );
  }

  /// `You can only purchase`
  String get youCanOnlyPurchase {
    return Intl.message(
      'You can only purchase',
      name: 'youCanOnlyPurchase',
      desc: '',
      args: [],
    );
  }

  /// `of this product`
  String get forThisProduct {
    return Intl.message(
      'of this product',
      name: 'forThisProduct',
      desc: '',
      args: [],
    );
  }

  /// `Currently we only have`
  String get currentlyWeOnlyHave {
    return Intl.message(
      'Currently we only have',
      name: 'currentlyWeOnlyHave',
      desc: '',
      args: [],
    );
  }

  /// `of this product`
  String get ofThisProduct {
    return Intl.message(
      'of this product',
      name: 'ofThisProduct',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `Total order value must be at least`
  String get totalCartValue {
    return Intl.message(
      'Total order value must be at least',
      name: 'totalCartValue',
      desc: '',
      args: [],
    );
  }

  /// `Hungarian`
  String get hungary {
    return Intl.message('Hungarian', name: 'hungary', desc: '', args: []);
  }

  /// `Apartment`
  String get streetNameApartment {
    return Intl.message(
      'Apartment',
      name: 'streetNameApartment',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get streetNameBlock {
    return Intl.message('Block', name: 'streetNameBlock', desc: '', args: []);
  }

  /// `By Tag`
  String get byTag {
    return Intl.message('By Tag', name: 'byTag', desc: '', args: []);
  }

  /// `Transaction cancelled`
  String get transactionCancelled {
    return Intl.message(
      'Transaction cancelled',
      name: 'transactionCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message('Tax', name: 'tax', desc: '', args: []);
  }

  /// `Sold by`
  String get soldBy {
    return Intl.message('Sold by', name: 'soldBy', desc: '', args: []);
  }

  /// `Shop Orders`
  String get shopOrders {
    return Intl.message('Shop Orders', name: 'shopOrders', desc: '', args: []);
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `SKU`
  String get sku {
    return Intl.message('SKU', name: 'sku', desc: '', args: []);
  }

  /// `There is a Discount Rule for applying your points to Cart`
  String get pointRewardMessage {
    return Intl.message(
      'There is a Discount Rule for applying your points to Cart',
      name: 'pointRewardMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your available points: {point}`
  String availablePoints(Object point) {
    return Intl.message(
      'Your available points: $point',
      name: 'availablePoints',
      desc: '',
      args: [point],
    );
  }

  /// `Select points`
  String get selectThePoint {
    return Intl.message(
      'Select points',
      name: 'selectThePoint',
      desc: '',
      args: [],
    );
  }

  /// `Cart Discount`
  String get cartDiscount {
    return Intl.message(
      'Cart Discount',
      name: 'cartDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Please choose an option for each attribute of the product`
  String get pleaseSelectAllAttributes {
    return Intl.message(
      'Please choose an option for each attribute of the product',
      name: 'pleaseSelectAllAttributes',
      desc: '',
      args: [],
    );
  }

  /// `Booking`
  String get booking {
    return Intl.message('Booking', name: 'booking', desc: '', args: []);
  }

  /// `Book Now`
  String get bookingNow {
    return Intl.message('Book Now', name: 'bookingNow', desc: '', args: []);
  }

  /// `Successfully Booked`
  String get bookingSuccess {
    return Intl.message(
      'Successfully Booked',
      name: 'bookingSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Already booked`
  String get booked {
    return Intl.message('Already booked', name: 'booked', desc: '', args: []);
  }

  /// `Waiting for confirmation`
  String get waitingForConfirmation {
    return Intl.message(
      'Waiting for confirmation',
      name: 'waitingForConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get bookingConfirm {
    return Intl.message(
      'Confirmed',
      name: 'bookingConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Booking Cancelled`
  String get bookingCancelled {
    return Intl.message(
      'Booking Cancelled',
      name: 'bookingCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Booking is unavailable`
  String get bookingUnavailable {
    return Intl.message(
      'Booking is unavailable',
      name: 'bookingUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Booking Summary`
  String get bookingSummary {
    return Intl.message(
      'Booking Summary',
      name: 'bookingSummary',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get dateEnd {
    return Intl.message('End Date', name: 'dateEnd', desc: '', args: []);
  }

  /// `Start Date`
  String get dateStart {
    return Intl.message('Start Date', name: 'dateStart', desc: '', args: []);
  }

  /// `Tickets`
  String get tickets {
    return Intl.message('Tickets', name: 'tickets', desc: '', args: []);
  }

  /// `Request Booking`
  String get requestBooking {
    return Intl.message(
      'Request Booking',
      name: 'requestBooking',
      desc: '',
      args: [],
    );
  }

  /// `Extra Services`
  String get extraServices {
    return Intl.message(
      'Extra Services',
      name: 'extraServices',
      desc: '',
      args: [],
    );
  }

  /// `Guests`
  String get guests {
    return Intl.message('Guests', name: 'guests', desc: '', args: []);
  }

  /// `Hour`
  String get hour {
    return Intl.message('Hour', name: 'hour', desc: '', args: []);
  }

  /// `Features`
  String get features {
    return Intl.message('Features', name: 'features', desc: '', args: []);
  }

  /// `Remove from Wishlist`
  String get removeFromWishList {
    return Intl.message(
      'Remove from Wishlist',
      name: 'removeFromWishList',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Menus`
  String get menus {
    return Intl.message('Menus', name: 'menus', desc: '', args: []);
  }

  /// `Prices`
  String get prices {
    return Intl.message('Prices', name: 'prices', desc: '', args: []);
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message('Total Price', name: 'totalPrice', desc: '', args: []);
  }

  /// `Add Listing`
  String get addListing {
    return Intl.message('Add Listing', name: 'addListing', desc: '', args: []);
  }

  /// `Booking History`
  String get bookingHistory {
    return Intl.message(
      'Booking History',
      name: 'bookingHistory',
      desc: '',
      args: [],
    );
  }

  /// `Vendor Admin`
  String get vendorAdmin {
    return Intl.message(
      'Vendor Admin',
      name: 'vendorAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russian {
    return Intl.message('Russian', name: 'russian', desc: '', args: []);
  }

  /// `Pick date & time`
  String get pickADate {
    return Intl.message(
      'Pick date & time',
      name: 'pickADate',
      desc: '',
      args: [],
    );
  }

  /// `on`
  String get on {
    return Intl.message('on', name: 'on', desc: '', args: []);
  }

  /// `Your booking details`
  String get yourBookingDetail {
    return Intl.message(
      'Your booking details',
      name: 'yourBookingDetail',
      desc: '',
      args: [],
    );
  }

  /// `Adults`
  String get adults {
    return Intl.message('Adults', name: 'adults', desc: '', args: []);
  }

  /// `Additional services`
  String get additionalServices {
    return Intl.message(
      'Additional services',
      name: 'additionalServices',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message('None', name: 'none', desc: '', args: []);
  }

  /// `This date is not available`
  String get thisDateIsNotAvailable {
    return Intl.message(
      'This date is not available',
      name: 'thisDateIsNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No slot available`
  String get noSlotAvailable {
    return Intl.message(
      'No slot available',
      name: 'noSlotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message('Pay Now', name: 'payNow', desc: '', args: []);
  }

  /// `Sold: {numberOfUnitsSold}`
  String sold(Object numberOfUnitsSold) {
    return Intl.message(
      'Sold: $numberOfUnitsSold',
      name: 'sold',
      desc: '',
      args: [numberOfUnitsSold],
    );
  }

  /// `Almost sold out`
  String get almostSoldOut {
    return Intl.message(
      'Almost sold out',
      name: 'almostSoldOut',
      desc: '',
      args: [],
    );
  }

  /// `Ends in {timeLeft}`
  String endsIn(Object timeLeft) {
    return Intl.message(
      'Ends in $timeLeft',
      name: 'endsIn',
      desc: '',
      args: [timeLeft],
    );
  }

  /// `Hebrew`
  String get hebrew {
    return Intl.message('Hebrew', name: 'hebrew', desc: '', args: []);
  }

  /// `Thai`
  String get thailand {
    return Intl.message('Thai', name: 'thailand', desc: '', args: []);
  }

  /// `Hungarian`
  String get hungarian {
    return Intl.message('Hungarian', name: 'hungarian', desc: '', args: []);
  }

  /// `Vendor Info`
  String get vendorInfo {
    return Intl.message('Vendor Info', name: 'vendorInfo', desc: '', args: []);
  }

  /// `Dutch`
  String get netherlands {
    return Intl.message('Dutch', name: 'netherlands', desc: '', args: []);
  }

  /// `Hindi`
  String get india {
    return Intl.message('Hindi', name: 'india', desc: '', args: []);
  }

  /// `Use Now`
  String get useNow {
    return Intl.message('Use Now', name: 'useNow', desc: '', args: []);
  }

  /// `Expired`
  String get expired {
    return Intl.message('Expired', name: 'expired', desc: '', args: []);
  }

  /// `Valid until {date}`
  String validUntilDate(Object date) {
    return Intl.message(
      'Valid until $date',
      name: 'validUntilDate',
      desc: '',
      args: [date],
    );
  }

  /// `Expiring in {time}`
  String expiringInTime(Object time) {
    return Intl.message(
      'Expiring in $time',
      name: 'expiringInTime',
      desc: '',
      args: [time],
    );
  }

  /// `Fixed Cart Discount`
  String get fixedCartDiscount {
    return Intl.message(
      'Fixed Cart Discount',
      name: 'fixedCartDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Fixed Product Discount`
  String get fixedProductDiscount {
    return Intl.message(
      'Fixed Product Discount',
      name: 'fixedProductDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Coupon has been saved successfully.`
  String get couponHasBeenSavedSuccessfully {
    return Intl.message(
      'Coupon has been saved successfully.',
      name: 'couponHasBeenSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Save For Later`
  String get saveForLater {
    return Intl.message(
      'Save For Later',
      name: 'saveForLater',
      desc: '',
      args: [],
    );
  }

  /// `Refund`
  String get refund {
    return Intl.message('Refund', name: 'refund', desc: '', args: []);
  }

  /// `Continue`
  String get continues {
    return Intl.message('Continue', name: 'continues', desc: '', args: []);
  }

  /// `Egypt`
  String get egypt {
    return Intl.message('Egypt', name: 'egypt', desc: '', args: []);
  }

  /// `Qty`
  String get qty {
    return Intl.message('Qty', name: 'qty', desc: '', args: []);
  }

  /// `Item total:`
  String get itemTotal {
    return Intl.message('Item total:', name: 'itemTotal', desc: '', args: []);
  }

  /// `Created on:`
  String get createdOn {
    return Intl.message('Created on:', name: 'createdOn', desc: '', args: []);
  }

  /// `Order ID:`
  String get orderId {
    return Intl.message('Order ID:', name: 'orderId', desc: '', args: []);
  }

  /// `Gross Sales`
  String get grossSales {
    return Intl.message('Gross Sales', name: 'grossSales', desc: '', args: []);
  }

  /// `Earnings`
  String get earnings {
    return Intl.message('Earnings', name: 'earnings', desc: '', args: []);
  }

  /// `Latest Sales`
  String get allOrders {
    return Intl.message('Latest Sales', name: 'allOrders', desc: '', args: []);
  }

  /// `Your earnings this month`
  String get yourEarningsThisMonth {
    return Intl.message(
      'Your earnings this month',
      name: 'yourEarningsThisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Search with Order ID...`
  String get searchOrderId {
    return Intl.message(
      'Search with Order ID...',
      name: 'searchOrderId',
      desc: '',
      args: [],
    );
  }

  /// `Your Orders`
  String get yourOrders {
    return Intl.message('Your Orders', name: 'yourOrders', desc: '', args: []);
  }

  /// `Edit Product Info`
  String get editProductInfo {
    return Intl.message(
      'Edit Product Info',
      name: 'editProductInfo',
      desc: '',
      args: [],
    );
  }

  /// `Can't find this order ID`
  String get cantFindThisOrderId {
    return Intl.message(
      'Can\'t find this order ID',
      name: 'cantFindThisOrderId',
      desc: '',
      args: [],
    );
  }

  /// `Show Details`
  String get showDetails {
    return Intl.message(
      'Show Details',
      name: 'showDetails',
      desc: '',
      args: [],
    );
  }

  /// `or login with`
  String get orLoginWith {
    return Intl.message(
      'or login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Delivered to`
  String get deliveredTo {
    return Intl.message(
      'Delivered to',
      name: 'deliveredTo',
      desc: '',
      args: [],
    );
  }

  /// `Order Total`
  String get orderTotal {
    return Intl.message('Order Total', name: 'orderTotal', desc: '', args: []);
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message('Add Product', name: 'addProduct', desc: '', args: []);
  }

  /// `Take Picture`
  String get takePicture {
    return Intl.message(
      'Take Picture',
      name: 'takePicture',
      desc: '',
      args: [],
    );
  }

  /// `Choose From Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose From Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Choose From Server`
  String get chooseFromServer {
    return Intl.message(
      'Choose From Server',
      name: 'chooseFromServer',
      desc: '',
      args: [],
    );
  }

  /// `Select Image`
  String get selectImage {
    return Intl.message(
      'Select Image',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `...more`
  String get more {
    return Intl.message('...more', name: 'more', desc: '', args: []);
  }

  /// `Upload Product`
  String get uploadProduct {
    return Intl.message(
      'Upload Product',
      name: 'uploadProduct',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Stock Quantity`
  String get stockQuantity {
    return Intl.message(
      'Stock Quantity',
      name: 'stockQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Manage Stock`
  String get manageStock {
    return Intl.message(
      'Manage Stock',
      name: 'manageStock',
      desc: '',
      args: [],
    );
  }

  /// `Short Description`
  String get shortDescription {
    return Intl.message(
      'Short Description',
      name: 'shortDescription',
      desc: '',
      args: [],
    );
  }

  /// `Update Info`
  String get updateInfo {
    return Intl.message('Update Info', name: 'updateInfo', desc: '', args: []);
  }

  /// `Stock`
  String get stock {
    return Intl.message('Stock', name: 'stock', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Approve`
  String get approve {
    return Intl.message('Approve', name: 'approve', desc: '', args: []);
  }

  /// `Approved`
  String get approved {
    return Intl.message('Approved', name: 'approved', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Review Approval`
  String get reviewApproval {
    return Intl.message(
      'Review Approval',
      name: 'reviewApproval',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `Update Status`
  String get updateStatus {
    return Intl.message(
      'Update Status',
      name: 'updateStatus',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get chatListScreen {
    return Intl.message('Messages', name: 'chatListScreen', desc: '', args: []);
  }

  /// `Card Number`
  String get cardNumber {
    return Intl.message('Card Number', name: 'cardNumber', desc: '', args: []);
  }

  /// `Expiration Date`
  String get expiredDate {
    return Intl.message(
      'Expiration Date',
      name: 'expiredDate',
      desc: '',
      args: [],
    );
  }

  /// `MM/YY`
  String get expiredDateHint {
    return Intl.message('MM/YY', name: 'expiredDateHint', desc: '', args: []);
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Card Holder`
  String get cardHolder {
    return Intl.message('Card Holder', name: 'cardHolder', desc: '', args: []);
  }

  /// `You must select 1 item`
  String get mustSelectOneItem {
    return Intl.message(
      'You must select 1 item',
      name: 'mustSelectOneItem',
      desc: '',
      args: [],
    );
  }

  /// `Options total: {price}`
  String optionsTotal(Object price) {
    return Intl.message(
      'Options total: $price',
      name: 'optionsTotal',
      desc: '',
      args: [price],
    );
  }

  /// `Options`
  String get options {
    return Intl.message('Options', name: 'options', desc: '', args: []);
  }

  /// `Please select the required options!`
  String get pleaseSelectRequiredOptions {
    return Intl.message(
      'Please select the required options!',
      name: 'pleaseSelectRequiredOptions',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Type your message here...`
  String get typeYourMessage {
    return Intl.message(
      'Type your message here...',
      name: 'typeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Edit:`
  String get edit {
    return Intl.message('Edit:', name: 'edit', desc: '', args: []);
  }

  /// `Edit`
  String get editWithoutColon {
    return Intl.message('Edit', name: 'editWithoutColon', desc: '', args: []);
  }

  /// `This feature does not support the current language`
  String get thisFeatureDoesNotSupportTheCurrentLanguage {
    return Intl.message(
      'This feature does not support the current language',
      name: 'thisFeatureDoesNotSupportTheCurrentLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message('Brand', name: 'brand', desc: '', args: []);
  }

  /// `Your review has been submitted and is awaiting approval!`
  String get reviewPendingApproval {
    return Intl.message(
      'Your review has been submitted and is awaiting approval!',
      name: 'reviewPendingApproval',
      desc: '',
      args: [],
    );
  }

  /// `Your review has been submitted!`
  String get reviewSent {
    return Intl.message(
      'Your review has been submitted!',
      name: 'reviewSent',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message('Publish', name: 'publish', desc: '', args: []);
  }

  /// `Private`
  String get private {
    return Intl.message('Private', name: 'private', desc: '', args: []);
  }

  /// `Draft`
  String get draft {
    return Intl.message('Draft', name: 'draft', desc: '', args: []);
  }

  /// `Simple`
  String get simple {
    return Intl.message('Simple', name: 'simple', desc: '', args: []);
  }

  /// `Grouped`
  String get grouped {
    return Intl.message('Grouped', name: 'grouped', desc: '', args: []);
  }

  /// `Variable`
  String get variable {
    return Intl.message('Variable', name: 'variable', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Uploading`
  String get uploading {
    return Intl.message('Uploading', name: 'uploading', desc: '', args: []);
  }

  /// `Upload file`
  String get uploadFile {
    return Intl.message('Upload file', name: 'uploadFile', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `File selection cancelled!`
  String get selectFileCancelled {
    return Intl.message(
      'File selection cancelled!',
      name: 'selectFileCancelled',
      desc: '',
      args: [],
    );
  }

  /// `The file is too big. Please choose a smaller file!`
  String get fileIsTooBig {
    return Intl.message(
      'The file is too big. Please choose a smaller file!',
      name: 'fileIsTooBig',
      desc: '',
      args: [],
    );
  }

  /// `File upload failed!`
  String get fileUploadFailed {
    return Intl.message(
      'File upload failed!',
      name: 'fileUploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `{total} products`
  String totalProducts(Object total) {
    return Intl.message(
      '$total products',
      name: 'totalProducts',
      desc: '',
      args: [total],
    );
  }

  /// `Add a name`
  String get addAName {
    return Intl.message('Add a name', name: 'addAName', desc: '', args: []);
  }

  /// `Add an attribute`
  String get addAnAttr {
    return Intl.message(
      'Add an attribute',
      name: 'addAnAttr',
      desc: '',
      args: [],
    );
  }

  /// `Add new`
  String get addNew {
    return Intl.message('Add new', name: 'addNew', desc: '', args: []);
  }

  /// `Select all`
  String get selectAll {
    return Intl.message('Select all', name: 'selectAll', desc: '', args: []);
  }

  /// `Select none`
  String get selectNone {
    return Intl.message('Select none', name: 'selectNone', desc: '', args: []);
  }

  /// `Visible`
  String get visible {
    return Intl.message('Visible', name: 'visible', desc: '', args: []);
  }

  /// `Variation`
  String get variation {
    return Intl.message('Variation', name: 'variation', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Direction`
  String get direction {
    return Intl.message('Direction', name: 'direction', desc: '', args: []);
  }

  /// `No listings nearby!`
  String get noListingNearby {
    return Intl.message(
      'No listings nearby!',
      name: 'noListingNearby',
      desc: '',
      args: [],
    );
  }

  /// `No stores nearby!`
  String get noStoreNearby {
    return Intl.message(
      'No stores nearby!',
      name: 'noStoreNearby',
      desc: '',
      args: [],
    );
  }

  /// `The email account you entered does not exist. Please try again.`
  String get emailDoesNotExist {
    return Intl.message(
      'The email account you entered does not exist. Please try again.',
      name: 'emailDoesNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get errorEmailFormat {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'errorEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password of at least 8 characters`
  String get errorPasswordFormat {
    return Intl.message(
      'Please enter a password of at least 8 characters',
      name: 'errorPasswordFormat',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear the cart?`
  String get confirmClearTheCart {
    return Intl.message(
      'Are you sure you want to clear the cart?',
      name: 'confirmClearTheCart',
      desc: '',
      args: [],
    );
  }

  /// `Keep`
  String get keep {
    return Intl.message('Keep', name: 'keep', desc: '', args: []);
  }

  /// `Serbian`
  String get serbian {
    return Intl.message('Serbian', name: 'serbian', desc: '', args: []);
  }

  /// `Polish`
  String get polish {
    return Intl.message('Polish', name: 'polish', desc: '', args: []);
  }

  /// `Persian`
  String get persian {
    return Intl.message('Persian', name: 'persian', desc: '', args: []);
  }

  /// `Kurdish`
  String get kurdish {
    return Intl.message('Kurdish', name: 'kurdish', desc: '', args: []);
  }

  /// `Please sign in to your account before uploading any files.`
  String get pleaseSignInBeforeUploading {
    return Intl.message(
      'Please sign in to your account before uploading any files.',
      name: 'pleaseSignInBeforeUploading',
      desc: '',
      args: [],
    );
  }

  /// `Maximum file size: {size} MB`
  String maximumFileSizeMb(Object size) {
    return Intl.message(
      'Maximum file size: $size MB',
      name: 'maximumFileSizeMb',
      desc: '',
      args: [size],
    );
  }

  /// `Login failed!`
  String get loginFailed {
    return Intl.message(
      'Login failed!',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get loginSuccess {
    return Intl.message(
      'Login successful!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `You are not allowed to use this app.`
  String get loginInvalid {
    return Intl.message(
      'You are not allowed to use this app.',
      name: 'loginInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Update failed!`
  String get updateFailed {
    return Intl.message(
      'Update failed!',
      name: 'updateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Update successful!`
  String get updateSuccess {
    return Intl.message(
      'Update successful!',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Ukrainian`
  String get ukrainian {
    return Intl.message('Ukrainian', name: 'ukrainian', desc: '', args: []);
  }

  /// `Bengali`
  String get bengali {
    return Intl.message('Bengali', name: 'bengali', desc: '', args: []);
  }

  /// `Chat with Store Owner`
  String get chatWithStoreOwner {
    return Intl.message(
      'Chat with Store Owner',
      name: 'chatWithStoreOwner',
      desc: '',
      args: [],
    );
  }

  /// `Chat via WhatsApp`
  String get chatViaWhatApp {
    return Intl.message(
      'Chat via WhatsApp',
      name: 'chatViaWhatApp',
      desc: '',
      args: [],
    );
  }

  /// `Chat via Facebook Messenger`
  String get chatViaFacebook {
    return Intl.message(
      'Chat via Facebook Messenger',
      name: 'chatViaFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Make a Call To`
  String get callTo {
    return Intl.message('Make a Call To', name: 'callTo', desc: '', args: []);
  }

  /// `Send Message To`
  String get messageTo {
    return Intl.message(
      'Send Message To',
      name: 'messageTo',
      desc: '',
      args: [],
    );
  }

  /// `Week {week}`
  String week(Object week) {
    return Intl.message('Week $week', name: 'week', desc: '', args: [week]);
  }

  /// `Store Settings`
  String get storeSettings {
    return Intl.message(
      'Store Settings',
      name: 'storeSettings',
      desc: '',
      args: [],
    );
  }

  /// `Store Logo`
  String get storeLogo {
    return Intl.message('Store Logo', name: 'storeLogo', desc: '', args: []);
  }

  /// `Link`
  String get link {
    return Intl.message('Link', name: 'link', desc: '', args: []);
  }

  /// `Shop name`
  String get shopName {
    return Intl.message('Shop name', name: 'shopName', desc: '', args: []);
  }

  /// `Shop slug`
  String get shopSlug {
    return Intl.message('Shop slug', name: 'shopSlug', desc: '', args: []);
  }

  /// `Shop email`
  String get shopEmail {
    return Intl.message('Shop email', name: 'shopEmail', desc: '', args: []);
  }

  /// `Shop phone`
  String get shopPhone {
    return Intl.message('Shop phone', name: 'shopPhone', desc: '', args: []);
  }

  /// `Banner Type`
  String get bannerType {
    return Intl.message('Banner Type', name: 'bannerType', desc: '', args: []);
  }

  /// `Store Static Banner`
  String get storeStaticBanner {
    return Intl.message(
      'Store Static Banner',
      name: 'storeStaticBanner',
      desc: '',
      args: [],
    );
  }

  /// `Store Slider Banner`
  String get storeSliderBanner {
    return Intl.message(
      'Store Slider Banner',
      name: 'storeSliderBanner',
      desc: '',
      args: [],
    );
  }

  /// `Banner Youtube URL`
  String get bannerYoutubeURL {
    return Intl.message(
      'Banner Youtube URL',
      name: 'bannerYoutubeURL',
      desc: '',
      args: [],
    );
  }

  /// `Store Mobile Banner`
  String get storeMobileBanner {
    return Intl.message(
      'Store Mobile Banner',
      name: 'storeMobileBanner',
      desc: '',
      args: [],
    );
  }

  /// `Banner List Type`
  String get bannerListType {
    return Intl.message(
      'Banner List Type',
      name: 'bannerListType',
      desc: '',
      args: [],
    );
  }

  /// `List Banner Type`
  String get listBannerType {
    return Intl.message(
      'List Banner Type',
      name: 'listBannerType',
      desc: '',
      args: [],
    );
  }

  /// `List Banner Video`
  String get listBannerVideo {
    return Intl.message(
      'List Banner Video',
      name: 'listBannerVideo',
      desc: '',
      args: [],
    );
  }

  /// `Store List Banner`
  String get storeListBanner {
    return Intl.message(
      'Store List Banner',
      name: 'storeListBanner',
      desc: '',
      args: [],
    );
  }

  /// `Street`
  String get street {
    return Intl.message('Street', name: 'street', desc: '', args: []);
  }

  /// `Street 2`
  String get street2 {
    return Intl.message('Street 2', name: 'street2', desc: '', args: []);
  }

  /// `Hide Email`
  String get hideEmail {
    return Intl.message('Hide Email', name: 'hideEmail', desc: '', args: []);
  }

  /// `Hide Phone`
  String get hidePhone {
    return Intl.message('Hide Phone', name: 'hidePhone', desc: '', args: []);
  }

  /// `Hide Address`
  String get hideAddress {
    return Intl.message(
      'Hide Address',
      name: 'hideAddress',
      desc: '',
      args: [],
    );
  }

  /// `Hide Map`
  String get hideMap {
    return Intl.message('Hide Map', name: 'hideMap', desc: '', args: []);
  }

  /// `Hide About`
  String get hideAbout {
    return Intl.message('Hide About', name: 'hideAbout', desc: '', args: []);
  }

  /// `Hide Policy`
  String get hidePolicy {
    return Intl.message('Hide Policy', name: 'hidePolicy', desc: '', args: []);
  }

  /// `Enter your email or username`
  String get enterYourEmailOrUsername {
    return Intl.message(
      'Enter your email or username',
      name: 'enterYourEmailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Enter your first name`
  String get enterYourFirstName {
    return Intl.message(
      'Enter your first name',
      name: 'enterYourFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your last name`
  String get enterYourLastName {
    return Intl.message(
      'Enter your last name',
      name: 'enterYourLastName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Your refund request has been submitted successfully!`
  String get refundOrderSuccess {
    return Intl.message(
      'Your refund request has been submitted successfully!',
      name: 'refundOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add a slug`
  String get addASlug {
    return Intl.message('Add a slug', name: 'addASlug', desc: '', args: []);
  }

  /// `The refund request was unsuccessful`
  String get refundOrderFailed {
    return Intl.message(
      'The refund request was unsuccessful',
      name: 'refundOrderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Are you sure you want to delete this item?`
  String get confirmDeleteItem {
    return Intl.message(
      'Are you sure you want to delete this item?',
      name: 'confirmDeleteItem',
      desc: '',
      args: [],
    );
  }

  /// `Mark as read`
  String get markAsRead {
    return Intl.message('Mark as read', name: 'markAsRead', desc: '', args: []);
  }

  /// `Mark as unread`
  String get markAsUnread {
    return Intl.message(
      'Mark as unread',
      name: 'markAsUnread',
      desc: '',
      args: [],
    );
  }

  /// `No file to download.`
  String get noFileToDownload {
    return Intl.message(
      'No file to download.',
      name: 'noFileToDownload',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get orderStatusShipped {
    return Intl.message(
      'Shipped',
      name: 'orderStatusShipped',
      desc: '',
      args: [],
    );
  }

  /// `Reversed`
  String get orderStatusReversed {
    return Intl.message(
      'Reversed',
      name: 'orderStatusReversed',
      desc: '',
      args: [],
    );
  }

  /// `Canceled Reversal`
  String get orderStatusCanceledReversal {
    return Intl.message(
      'Canceled Reversal',
      name: 'orderStatusCanceledReversal',
      desc: '',
      args: [],
    );
  }

  /// `Charge Back`
  String get orderStatusChargeBack {
    return Intl.message(
      'Charge Back',
      name: 'orderStatusChargeBack',
      desc: '',
      args: [],
    );
  }

  /// `Denied`
  String get orderStatusDenied {
    return Intl.message(
      'Denied',
      name: 'orderStatusDenied',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get orderStatusExpired {
    return Intl.message(
      'Expired',
      name: 'orderStatusExpired',
      desc: '',
      args: [],
    );
  }

  /// `Processed`
  String get orderStatusProcessed {
    return Intl.message(
      'Processed',
      name: 'orderStatusProcessed',
      desc: '',
      args: [],
    );
  }

  /// `Voided`
  String get orderStatusVoided {
    return Intl.message(
      'Voided',
      name: 'orderStatusVoided',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Ready to pick`
  String get readyToPick {
    return Intl.message(
      'Ready to pick',
      name: 'readyToPick',
      desc: '',
      args: [],
    );
  }

  /// `Picking`
  String get picking {
    return Intl.message('Picking', name: 'picking', desc: '', args: []);
  }

  /// `Delivering`
  String get delivering {
    return Intl.message('Delivering', name: 'delivering', desc: '', args: []);
  }

  /// `Incorrect password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `The registration is invalid`
  String get registerInvalid {
    return Intl.message(
      'The registration is invalid',
      name: 'registerInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Unable to sync account with server`
  String get registerErrorSyncAccount {
    return Intl.message(
      'Unable to sync account with server',
      name: 'registerErrorSyncAccount',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Details`
  String get deliveryDetails {
    return Intl.message(
      'Delivery Details',
      name: 'deliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Assigned`
  String get assigned {
    return Intl.message('Assigned', name: 'assigned', desc: '', args: []);
  }

  /// `Call`
  String get call {
    return Intl.message('Call', name: 'call', desc: '', args: []);
  }

  /// `Full name`
  String get fullName {
    return Intl.message('Full name', name: 'fullName', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Update password`
  String get updatePassword {
    return Intl.message(
      'Update password',
      name: 'updatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Customer details`
  String get customerDetail {
    return Intl.message(
      'Customer details',
      name: 'customerDetail',
      desc: '',
      args: [],
    );
  }

  /// `Store Information`
  String get storeInformation {
    return Intl.message(
      'Store Information',
      name: 'storeInformation',
      desc: '',
      args: [],
    );
  }

  /// `Mark as shipped`
  String get markAsShipped {
    return Intl.message(
      'Mark as shipped',
      name: 'markAsShipped',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get shipped {
    return Intl.message('Shipped', name: 'shipped', desc: '', args: []);
  }

  /// `Your product will appear after review.`
  String get productCreateReview {
    return Intl.message(
      'Your product will appear after review.',
      name: 'productCreateReview',
      desc: '',
      args: [],
    );
  }

  /// `Your post has been created successfully`
  String get postSuccessfully {
    return Intl.message(
      'Your post has been created successfully',
      name: 'postSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your post could not be created`
  String get postFail {
    return Intl.message(
      'Your post could not be created',
      name: 'postFail',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get postTitle {
    return Intl.message('Title', name: 'postTitle', desc: '', args: []);
  }

  /// `Content`
  String get postContent {
    return Intl.message('Content', name: 'postContent', desc: '', args: []);
  }

  /// `Featured Image`
  String get postImageFeature {
    return Intl.message(
      'Featured Image',
      name: 'postImageFeature',
      desc: '',
      args: [],
    );
  }

  /// `Submit Your Post`
  String get submitYourPost {
    return Intl.message(
      'Submit Your Post',
      name: 'submitYourPost',
      desc: '',
      args: [],
    );
  }

  /// `Post Management`
  String get postManagement {
    return Intl.message(
      'Post Management',
      name: 'postManagement',
      desc: '',
      args: [],
    );
  }

  /// `Create New Post`
  String get addNewPost {
    return Intl.message(
      'Create New Post',
      name: 'addNewPost',
      desc: '',
      args: [],
    );
  }

  /// `{month} months ago`
  String monthsAgo(Object month) {
    return Intl.message(
      '$month months ago',
      name: 'monthsAgo',
      desc: '',
      args: [month],
    );
  }

  /// `{year} years ago`
  String yearsAgo(Object year) {
    return Intl.message(
      '$year years ago',
      name: 'yearsAgo',
      desc: '',
      args: [year],
    );
  }

  /// `We Found Blog(s)`
  String get weFoundBlogs {
    return Intl.message(
      'We Found Blog(s)',
      name: 'weFoundBlogs',
      desc: '',
      args: [],
    );
  }

  /// `Start Exploring`
  String get startExploring {
    return Intl.message(
      'Start Exploring',
      name: 'startExploring',
      desc: '',
      args: [],
    );
  }

  /// `Explore Now`
  String get exploreNow {
    return Intl.message('Explore Now', name: 'exploreNow', desc: '', args: []);
  }

  /// `Comment submitted successfully, please wait until your comment is approved`
  String get commentSuccessfully {
    return Intl.message(
      'Comment submitted successfully, please wait until your comment is approved',
      name: 'commentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please Login To Comment`
  String get loginToComment {
    return Intl.message(
      'Please Login To Comment',
      name: 'loginToComment',
      desc: '',
      args: [],
    );
  }

  /// `Page View`
  String get pageView {
    return Intl.message('Page View', name: 'pageView', desc: '', args: []);
  }

  /// `Add New Blog`
  String get addNewBlog {
    return Intl.message('Add New Blog', name: 'addNewBlog', desc: '', args: []);
  }

  /// `a moment ago`
  String get momentAgo {
    return Intl.message('a moment ago', name: 'momentAgo', desc: '', args: []);
  }

  /// `Web View`
  String get webView {
    return Intl.message('Web View', name: 'webView', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Add A New Post`
  String get addANewPost {
    return Intl.message(
      'Add A New Post',
      name: 'addANewPost',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Content`
  String get content {
    return Intl.message('Content', name: 'content', desc: '', args: []);
  }

  /// `Featured Image`
  String get imageFeature {
    return Intl.message(
      'Featured Image',
      name: 'imageFeature',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Your post has been successfully created as a draft. Please take a look at your admin site.`
  String get createNewPostSuccessfully {
    return Intl.message(
      'Your post has been successfully created as a draft. Please take a look at your admin site.',
      name: 'createNewPostSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `You haven't searched for items yet. Let's start now - we'll help you.`
  String get emptySearch {
    return Intl.message(
      'You haven\'t searched for items yet. Let\'s start now - we\'ll help you.',
      name: 'emptySearch',
      desc: '',
      args: [],
    );
  }

  /// `Create Post`
  String get createPost {
    return Intl.message('Create Post', name: 'createPost', desc: '', args: []);
  }

  /// `Your comment cannot be empty`
  String get emptyComment {
    return Intl.message(
      'Your comment cannot be empty',
      name: 'emptyComment',
      desc: '',
      args: [],
    );
  }

  /// `Hindi`
  String get hindi {
    return Intl.message('Hindi', name: 'hindi', desc: '', args: []);
  }

  /// `Korean`
  String get korean {
    return Intl.message('Korean', name: 'korean', desc: '', args: []);
  }

  /// `Dutch`
  String get dutch {
    return Intl.message('Dutch', name: 'dutch', desc: '', args: []);
  }

  /// `Things You Might Love`
  String get relatedLayoutTitle {
    return Intl.message(
      'Things You Might Love',
      name: 'relatedLayoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Audio item(s) detected. Do you want to add to Audio Player?`
  String get audioDetected {
    return Intl.message(
      'Audio item(s) detected. Do you want to add to Audio Player?',
      name: 'audioDetected',
      desc: '',
      args: [],
    );
  }

  /// `Date ascending`
  String get dateASC {
    return Intl.message('Date ascending', name: 'dateASC', desc: '', args: []);
  }

  /// `Date descending`
  String get dateDESC {
    return Intl.message(
      'Date descending',
      name: 'dateDESC',
      desc: '',
      args: [],
    );
  }

  /// `See Order`
  String get seeOrder {
    return Intl.message('See Order', name: 'seeOrder', desc: '', args: []);
  }

  /// `Open Map`
  String get openMap {
    return Intl.message('Open Map', name: 'openMap', desc: '', args: []);
  }

  /// `All Orders`
  String get allDeliveryOrders {
    return Intl.message(
      'All Orders',
      name: 'allDeliveryOrders',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Order Note`
  String get note {
    return Intl.message('Order Note', name: 'note', desc: '', args: []);
  }

  /// `Search with Name...`
  String get searchByName {
    return Intl.message(
      'Search with Name...',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `Order ID`
  String get orderIdWithoutColon {
    return Intl.message(
      'Order ID',
      name: 'orderIdWithoutColon',
      desc: '',
      args: [],
    );
  }

  /// `No Data.\nThis order has been removed.`
  String get deliveryNotificationError {
    return Intl.message(
      'No Data.\nThis order has been removed.',
      name: 'deliveryNotificationError',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get deliveryManagement {
    return Intl.message(
      'Delivery',
      name: 'deliveryManagement',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Boy`
  String get deliveryBoy {
    return Intl.message(
      'Delivery Boy',
      name: 'deliveryBoy',
      desc: '',
      args: [],
    );
  }

  /// `Recurring Totals`
  String get recurringTotals {
    return Intl.message(
      'Recurring Totals',
      name: 'recurringTotals',
      desc: '',
      args: [],
    );
  }

  /// `First Renewal`
  String get firstRenewal {
    return Intl.message(
      'First Renewal',
      name: 'firstRenewal',
      desc: '',
      args: [],
    );
  }

  /// `At least 3 characters...`
  String get atLeastThreeCharacters {
    return Intl.message(
      'At least 3 characters...',
      name: 'atLeastThreeCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get popular {
    return Intl.message('Popular', name: 'popular', desc: '', args: []);
  }

  /// `Latest Products`
  String get latestProducts {
    return Intl.message(
      'Latest Products',
      name: 'latestProducts',
      desc: '',
      args: [],
    );
  }

  /// `See reviews`
  String get seeReviews {
    return Intl.message('See reviews', name: 'seeReviews', desc: '', args: []);
  }

  /// `Delivery Date`
  String get deliveryDate {
    return Intl.message(
      'Delivery Date',
      name: 'deliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `You have been assigned to order #{total}`
  String youHaveAssignedToOrder(Object total) {
    return Intl.message(
      'You have been assigned to order #$total',
      name: 'youHaveAssignedToOrder',
      desc: '',
      args: [total],
    );
  }

  /// `~{total} km`
  String distance(Object total) {
    return Intl.message(
      '~$total km',
      name: 'distance',
      desc: '',
      args: [total],
    );
  }

  /// `Registration failed`
  String get registerFailed {
    return Intl.message(
      'Registration failed',
      name: 'registerFailed',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get registerSuccess {
    return Intl.message(
      'Registration successful',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Phone Number`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid Phone Number',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `You have requested too many codes in a short time. Please try again later.`
  String get requestTooMany {
    return Intl.message(
      'You have requested too many codes in a short time. Please try again later.',
      name: 'requestTooMany',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is empty`
  String get phoneEmpty {
    return Intl.message(
      'Phone number is empty',
      name: 'phoneEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Choose Plan`
  String get choosePlan {
    return Intl.message('Choose Plan', name: 'choosePlan', desc: '', args: []);
  }

  /// `Recommended`
  String get recommended {
    return Intl.message('Recommended', name: 'recommended', desc: '', args: []);
  }

  /// `Paid status`
  String get paidStatus {
    return Intl.message('Paid status', name: 'paidStatus', desc: '', args: []);
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Unpaid`
  String get unpaid {
    return Intl.message('Unpaid', name: 'unpaid', desc: '', args: []);
  }

  /// `Mobile Verification`
  String get mobileVerification {
    return Intl.message(
      'Mobile Verification',
      name: 'mobileVerification',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mobile number`
  String get enterYourMobile {
    return Intl.message(
      'Please enter your mobile number',
      name: 'enterYourMobile',
      desc: '',
      args: [],
    );
  }

  /// `Format: +84123456789`
  String get phoneHintFormat {
    return Intl.message(
      'Format: +84123456789',
      name: 'phoneHintFormat',
      desc: '',
      args: [],
    );
  }

  /// `Verification code (6 digits)`
  String get verificationCode {
    return Intl.message(
      'Verification code (6 digits)',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `This username/email is not available.`
  String get userExists {
    return Intl.message(
      'This username/email is not available.',
      name: 'userExists',
      desc: '',
      args: [],
    );
  }

  /// `Account setup`
  String get accountSetup {
    return Intl.message(
      'Account setup',
      name: 'accountSetup',
      desc: '',
      args: [],
    );
  }

  /// `You won't be asked next time after completion`
  String get youNotBeAsked {
    return Intl.message(
      'You won\'t be asked next time after completion',
      name: 'youNotBeAsked',
      desc: '',
      args: [],
    );
  }

  /// `Open now`
  String get openNow {
    return Intl.message('Open now', name: 'openNow', desc: '', args: []);
  }

  /// `Closed now`
  String get closeNow {
    return Intl.message('Closed now', name: 'closeNow', desc: '', args: []);
  }

  /// `The store is closed now`
  String get storeClosed {
    return Intl.message(
      'The store is closed now',
      name: 'storeClosed',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Be the first one to comment on this post!`
  String get firstComment {
    return Intl.message(
      'Be the first one to comment on this post!',
      name: 'firstComment',
      desc: '',
      args: [],
    );
  }

  /// `>{total} km`
  String greaterDistance(Object total) {
    return Intl.message(
      '>$total km',
      name: 'greaterDistance',
      desc: '',
      args: [total],
    );
  }

  /// `The maximum quantity has been exceeded`
  String get addToCartMaximum {
    return Intl.message(
      'The maximum quantity has been exceeded',
      name: 'addToCartMaximum',
      desc: '',
      args: [],
    );
  }

  /// `Play All`
  String get playAll {
    return Intl.message('Play All', name: 'playAll', desc: '', args: []);
  }

  /// `Customer note`
  String get customerNote {
    return Intl.message(
      'Customer note',
      name: 'customerNote',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `You can only purchase from a single store.`
  String get youCanOnlyOrderSingleStore {
    return Intl.message(
      'You can only purchase from a single store.',
      name: 'youCanOnlyOrderSingleStore',
      desc: '',
      args: [],
    );
  }

  /// `Instantly close`
  String get instantlyClose {
    return Intl.message(
      'Instantly close',
      name: 'instantlyClose',
      desc: '',
      args: [],
    );
  }

  /// `Date wise close`
  String get dateWiseClose {
    return Intl.message(
      'Date wise close',
      name: 'dateWiseClose',
      desc: '',
      args: [],
    );
  }

  /// `Enable vacation mode`
  String get enableVacationMode {
    return Intl.message(
      'Enable vacation mode',
      name: 'enableVacationMode',
      desc: '',
      args: [],
    );
  }

  /// `Disable purchase`
  String get disablePurchase {
    return Intl.message(
      'Disable purchase',
      name: 'disablePurchase',
      desc: '',
      args: [],
    );
  }

  /// `Vacation type`
  String get vacationType {
    return Intl.message(
      'Vacation type',
      name: 'vacationType',
      desc: '',
      args: [],
    );
  }

  /// `Select dates`
  String get selectDates {
    return Intl.message(
      'Select dates',
      name: 'selectDates',
      desc: '',
      args: [],
    );
  }

  /// `Vacation Message`
  String get vacationMessage {
    return Intl.message(
      'Vacation Message',
      name: 'vacationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Store vacation`
  String get storeVacation {
    return Intl.message(
      'Store vacation',
      name: 'storeVacation',
      desc: '',
      args: [],
    );
  }

  /// `Date in the past is not allowed`
  String get cantPickDateInThePast {
    return Intl.message(
      'Date in the past is not allowed',
      name: 'cantPickDateInThePast',
      desc: '',
      args: [],
    );
  }

  /// `Please select a date after first date`
  String get endDateCantBeAfterFirstDate {
    return Intl.message(
      'Please select a date after first date',
      name: 'endDateCantBeAfterFirstDate',
      desc: '',
      args: [],
    );
  }

  /// `On vacation`
  String get onVacation {
    return Intl.message('On vacation', name: 'onVacation', desc: '', args: []);
  }

  /// `Refund Requested`
  String get refundRequested {
    return Intl.message(
      'Refund Requested',
      name: 'refundRequested',
      desc: '',
      args: [],
    );
  }

  /// `My Wallet`
  String get myWallet {
    return Intl.message('My Wallet', name: 'myWallet', desc: '', args: []);
  }

  /// `Via wallet`
  String get viaWallet {
    return Intl.message('Via wallet', name: 'viaWallet', desc: '', args: []);
  }

  /// `Pay by wallet`
  String get payByWallet {
    return Intl.message(
      'Pay by wallet',
      name: 'payByWallet',
      desc: '',
      args: [],
    );
  }

  /// `Last Transactions`
  String get lastTransactions {
    return Intl.message(
      'Last Transactions',
      name: 'lastTransactions',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any transactions yet`
  String get doNotAnyTransactions {
    return Intl.message(
      'You don\'t have any transactions yet',
      name: 'doNotAnyTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Top Up`
  String get topUp {
    return Intl.message('Top Up', name: 'topUp', desc: '', args: []);
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `History`
  String get historyTransaction {
    return Intl.message(
      'History',
      name: 'historyTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Top Up product not found`
  String get topUpProductNotFound {
    return Intl.message(
      'Top Up product not found',
      name: 'topUpProductNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Result`
  String get transactionResult {
    return Intl.message(
      'Transaction Result',
      name: 'transactionResult',
      desc: '',
      args: [],
    );
  }

  /// `Transfer failed!`
  String get transferFailed {
    return Intl.message(
      'Transfer failed!',
      name: 'transferFailed',
      desc: '',
      args: [],
    );
  }

  /// `Entered amount is greater than current wallet amount. Please try again!`
  String get errorAmountTransfer {
    return Intl.message(
      'Entered amount is greater than current wallet amount. Please try again!',
      name: 'errorAmountTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Back to Wallet`
  String get backToWallet {
    return Intl.message(
      'Back to Wallet',
      name: 'backToWallet',
      desc: '',
      args: [],
    );
  }

  /// `Transfer successful`
  String get transferSuccess {
    return Intl.message(
      'Transfer successful',
      name: 'transferSuccess',
      desc: '',
      args: [],
    );
  }

  /// `View recent transactions`
  String get viewRecentTransactions {
    return Intl.message(
      'View recent transactions',
      name: 'viewRecentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Note (optional)`
  String get noteTransfer {
    return Intl.message(
      'Note (optional)',
      name: 'noteTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Confirmation`
  String get transferConfirm {
    return Intl.message(
      'Transfer Confirmation',
      name: 'transferConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `The cart will be cleared when topping up.`
  String get confirmClearCartWhenTopUp {
    return Intl.message(
      'The cart will be cleared when topping up.',
      name: 'confirmClearCartWhenTopUp',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this product?`
  String get confirmRemoveProductInCart {
    return Intl.message(
      'Are you sure you want to remove this product?',
      name: 'confirmRemoveProductInCart',
      desc: '',
      args: [],
    );
  }

  /// `The currently selected currency is not available for the Wallet feature, please change it to {defaultCurrency}`
  String warningCurrencyMessageForWallet(Object defaultCurrency) {
    return Intl.message(
      'The currently selected currency is not available for the Wallet feature, please change it to $defaultCurrency',
      name: 'warningCurrencyMessageForWallet',
      desc: '',
      args: [defaultCurrency],
    );
  }

  /// `You can't transfer to this user`
  String get transferErrorMessage {
    return Intl.message(
      'You can\'t transfer to this user',
      name: 'transferErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Czech`
  String get czech {
    return Intl.message('Czech', name: 'czech', desc: '', args: []);
  }

  /// `Choose category`
  String get chooseCategory {
    return Intl.message(
      'Choose category',
      name: 'chooseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Choose type`
  String get chooseType {
    return Intl.message('Choose type', name: 'chooseType', desc: '', args: []);
  }

  /// `External`
  String get external {
    return Intl.message('External', name: 'external', desc: '', args: []);
  }

  /// `Please choose category`
  String get pleaseChooseCategory {
    return Intl.message(
      'Please choose category',
      name: 'pleaseChooseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please add price`
  String get pleaseAddPrice {
    return Intl.message(
      'Please add price',
      name: 'pleaseAddPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the product name`
  String get pleaseEnterProductName {
    return Intl.message(
      'Please enter the product name',
      name: 'pleaseEnterProductName',
      desc: '',
      args: [],
    );
  }

  /// `has been deleted`
  String get hasBeenDeleted {
    return Intl.message(
      'has been deleted',
      name: 'hasBeenDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basicInformation {
    return Intl.message(
      'Basic Information',
      name: 'basicInformation',
      desc: '',
      args: [],
    );
  }

  /// `Shop Email`
  String get storeEmail {
    return Intl.message('Shop Email', name: 'storeEmail', desc: '', args: []);
  }

  /// `Maximum discount point`
  String get pointMsgMaximumDiscountPoint {
    return Intl.message(
      'Maximum discount point',
      name: 'pointMsgMaximumDiscountPoint',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the maximum discount point`
  String get pointMsgOverMaximumDiscountPoint {
    return Intl.message(
      'You have reached the maximum discount point',
      name: 'pointMsgOverMaximumDiscountPoint',
      desc: '',
      args: [],
    );
  }

  /// `Discount point applied successfully`
  String get pointMsgSuccess {
    return Intl.message(
      'Discount point applied successfully',
      name: 'pointMsgSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Discount point removed`
  String get pointMsgRemove {
    return Intl.message(
      'Discount point removed',
      name: 'pointMsgRemove',
      desc: '',
      args: [],
    );
  }

  /// `Please enter discount point`
  String get pointMsgEnter {
    return Intl.message(
      'Please enter discount point',
      name: 'pointMsgEnter',
      desc: '',
      args: [],
    );
  }

  /// `Prepaid`
  String get prepaid {
    return Intl.message('Prepaid', name: 'prepaid', desc: '', args: []);
  }

  /// `The total discount value exceeds the bill total`
  String get pointMsgOverTotalBill {
    return Intl.message(
      'The total discount value exceeds the bill total',
      name: 'pointMsgOverTotalBill',
      desc: '',
      args: [],
    );
  }

  /// `No discount point configuration has been found on the server`
  String get pointMsgConfigNotFound {
    return Intl.message(
      'No discount point configuration has been found on the server',
      name: 'pointMsgConfigNotFound',
      desc: '',
      args: [],
    );
  }

  /// `You don't have enough discount points. Your total discount point is`
  String get pointMsgNotEnough {
    return Intl.message(
      'You don\'t have enough discount points. Your total discount point is',
      name: 'pointMsgNotEnough',
      desc: '',
      args: [],
    );
  }

  /// `To scan an order, you need to log in first`
  String get scannerLoginFirst {
    return Intl.message(
      'To scan an order, you need to log in first',
      name: 'scannerLoginFirst',
      desc: '',
      args: [],
    );
  }

  /// `This item cannot be scanned`
  String get scannerCannotScan {
    return Intl.message(
      'This item cannot be scanned',
      name: 'scannerCannotScan',
      desc: '',
      args: [],
    );
  }

  /// `This order is not available for your account`
  String get scannerOrderAvailable {
    return Intl.message(
      'This order is not available for your account',
      name: 'scannerOrderAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Shop Address`
  String get storeAddress {
    return Intl.message(
      'Shop Address',
      name: 'storeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Store Brand`
  String get storeBrand {
    return Intl.message('Store Brand', name: 'storeBrand', desc: '', args: []);
  }

  /// `Store Location`
  String get storeLocation {
    return Intl.message(
      'Store Location',
      name: 'storeLocation',
      desc: '',
      args: [],
    );
  }

  /// `Please select images`
  String get pleaseSelectImages {
    return Intl.message(
      'Please select images',
      name: 'pleaseSelectImages',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location`
  String get pleaseSelectALocation {
    return Intl.message(
      'Please select a location',
      name: 'pleaseSelectALocation',
      desc: '',
      args: [],
    );
  }

  /// `Banner`
  String get storeBanner {
    return Intl.message('Banner', name: 'storeBanner', desc: '', args: []);
  }

  /// `Finish setup`
  String get finishSetup {
    return Intl.message(
      'Finish setup',
      name: 'finishSetup',
      desc: '',
      args: [],
    );
  }

  /// `Is everything set...?`
  String get isEverythingSet {
    return Intl.message(
      'Is everything set...?',
      name: 'isEverythingSet',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Something went wrong. Please try again later.`
  String get somethingWrong {
    return Intl.message(
      'Something went wrong. Please try again later.',
      name: 'somethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `Choose Staff`
  String get chooseStaff {
    return Intl.message(
      'Choose Staff',
      name: 'chooseStaff',
      desc: '',
      args: [],
    );
  }

  /// `Morning`
  String get morning {
    return Intl.message('Morning', name: 'morning', desc: '', args: []);
  }

  /// `Afternoon`
  String get afternoon {
    return Intl.message('Afternoon', name: 'afternoon', desc: '', args: []);
  }

  /// `Evening`
  String get evening {
    return Intl.message('Evening', name: 'evening', desc: '', args: []);
  }

  /// `Expected Delivery Date`
  String get expectedDeliveryDate {
    return Intl.message(
      'Expected Delivery Date',
      name: 'expectedDeliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Qty: {total}`
  String qtyTotal(Object total) {
    return Intl.message(
      'Qty: $total',
      name: 'qtyTotal',
      desc: '',
      args: [total],
    );
  }

  /// `Added`
  String get added {
    return Intl.message('Added', name: 'added', desc: '', args: []);
  }

  /// `Re-order`
  String get reOrder {
    return Intl.message('Re-order', name: 'reOrder', desc: '', args: []);
  }

  /// `Your order has been added`
  String get yourOrderHasBeenAdded {
    return Intl.message(
      'Your order has been added',
      name: 'yourOrderHasBeenAdded',
      desc: '',
      args: [],
    );
  }

  /// `Swedish`
  String get swedish {
    return Intl.message('Swedish', name: 'swedish', desc: '', args: []);
  }

  /// `Finnish`
  String get finnish {
    return Intl.message('Finnish', name: 'finnish', desc: '', args: []);
  }

  /// `Greek`
  String get greek {
    return Intl.message('Greek', name: 'greek', desc: '', args: []);
  }

  /// `Tamil`
  String get tamil {
    return Intl.message('Tamil', name: 'tamil', desc: '', args: []);
  }

  /// `Khmer`
  String get khmer {
    return Intl.message('Khmer', name: 'khmer', desc: '', args: []);
  }

  /// `Please select a booking date`
  String get pleaseSelectADate {
    return Intl.message(
      'Please select a booking date',
      name: 'pleaseSelectADate',
      desc: '',
      args: [],
    );
  }

  /// `All Brands`
  String get allBrands {
    return Intl.message('All Brands', name: 'allBrands', desc: '', args: []);
  }

  /// `Kannada`
  String get kannada {
    return Intl.message('Kannada', name: 'kannada', desc: '', args: []);
  }

  /// `Marathi`
  String get marathi {
    return Intl.message('Marathi', name: 'marathi', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `State`
  String get state {
    return Intl.message('State', name: 'state', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Add to order`
  String get addToOrder {
    return Intl.message('Add to order', name: 'addToOrder', desc: '', args: []);
  }

  /// `Invoice`
  String get invoice {
    return Intl.message('Invoice', name: 'invoice', desc: '', args: []);
  }

  /// `Complete`
  String get complete {
    return Intl.message('Complete', name: 'complete', desc: '', args: []);
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Malay`
  String get malay {
    return Intl.message('Malay', name: 'malay', desc: '', args: []);
  }

  /// `Bosnian`
  String get bosnian {
    return Intl.message('Bosnian', name: 'bosnian', desc: '', args: []);
  }

  /// `All Products`
  String get allProducts {
    return Intl.message(
      'All Products',
      name: 'allProducts',
      desc: '',
      args: [],
    );
  }

  /// `Lao`
  String get lao {
    return Intl.message('Lao', name: 'lao', desc: '', args: []);
  }

  /// `Slovak`
  String get slovak {
    return Intl.message('Slovak', name: 'slovak', desc: '', args: []);
  }

  /// `Swahili`
  String get swahili {
    return Intl.message('Swahili', name: 'swahili', desc: '', args: []);
  }

  /// `This address will be saved to your local device. It is NOT the user address.`
  String get posAddressToolTip {
    return Intl.message(
      'This address will be saved to your local device. It is NOT the user address.',
      name: 'posAddressToolTip',
      desc: '',
      args: [],
    );
  }

  /// `Username and password are required`
  String get usernameAndPasswordRequired {
    return Intl.message(
      'Username and password are required',
      name: 'usernameAndPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to continue`
  String get loginToContinue {
    return Intl.message(
      'Please log in to continue',
      name: 'loginToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get doYouWantToLogout {
    return Intl.message(
      'Do you want to log out?',
      name: 'doYouWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Please set an address in the settings page`
  String get setAnAddressInSettingPage {
    return Intl.message(
      'Please set an address in the settings page',
      name: 'setAnAddressInSettingPage',
      desc: '',
      args: [],
    );
  }

  /// `Received money`
  String get receivedMoney {
    return Intl.message(
      'Received money',
      name: 'receivedMoney',
      desc: '',
      args: [],
    );
  }

  /// `Debit`
  String get debit {
    return Intl.message('Debit', name: 'debit', desc: '', args: []);
  }

  /// `Transaction detail`
  String get transactionDetail {
    return Intl.message(
      'Transaction detail',
      name: 'transactionDetail',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful`
  String get paymentSuccessful {
    return Intl.message(
      'Payment successful',
      name: 'paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Transaction fee`
  String get transactionFee {
    return Intl.message(
      'Transaction fee',
      name: 'transactionFee',
      desc: '',
      args: [],
    );
  }

  /// `Free of charge`
  String get freeOfCharge {
    return Intl.message(
      'Free of charge',
      name: 'freeOfCharge',
      desc: '',
      args: [],
    );
  }

  /// `Wallet balance`
  String get walletBalance {
    return Intl.message(
      'Wallet balance',
      name: 'walletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Wallet balance: {balance}`
  String walletBalanceWithValue(Object balance) {
    return Intl.message(
      'Wallet balance: $balance',
      name: 'walletBalanceWithValue',
      desc: '',
      args: [balance],
    );
  }

  /// `More information`
  String get moreInformation {
    return Intl.message(
      'More information',
      name: 'moreInformation',
      desc: '',
      args: [],
    );
  }

  /// `Wallet name`
  String get walletName {
    return Intl.message('Wallet name', name: 'walletName', desc: '', args: []);
  }

  /// `note`
  String get noteMessage {
    return Intl.message('note', name: 'noteMessage', desc: '', args: []);
  }

  /// `Send back`
  String get sendBack {
    return Intl.message('Send back', name: 'sendBack', desc: '', args: []);
  }

  /// `No Printers`
  String get noPrinters {
    return Intl.message('No Printers', name: 'noPrinters', desc: '', args: []);
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Checking...`
  String get checking {
    return Intl.message('Checking...', name: 'checking', desc: '', args: []);
  }

  /// `Printing...`
  String get printing {
    return Intl.message('Printing...', name: 'printing', desc: '', args: []);
  }

  /// `Turn On Bluetooth`
  String get turnOnBle {
    return Intl.message(
      'Turn On Bluetooth',
      name: 'turnOnBle',
      desc: '',
      args: [],
    );
  }

  /// `Date Time`
  String get dateTime {
    return Intl.message('Date Time', name: 'dateTime', desc: '', args: []);
  }

  /// `Order Number`
  String get orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Print Receipt`
  String get printReceipt {
    return Intl.message(
      'Print Receipt',
      name: 'printReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Printer Selection`
  String get printerSelection {
    return Intl.message(
      'Printer Selection',
      name: 'printerSelection',
      desc: '',
      args: [],
    );
  }

  /// `The printer was not found`
  String get printerNotFound {
    return Intl.message(
      'The printer was not found',
      name: 'printerNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message('Item', name: 'item', desc: '', args: []);
  }

  /// `{count} item`
  String countItem(Object count) {
    return Intl.message(
      '$count item',
      name: 'countItem',
      desc: '',
      args: [count],
    );
  }

  /// `{count} items`
  String countItems(Object count) {
    return Intl.message(
      '$count items',
      name: 'countItems',
      desc: '',
      args: [count],
    );
  }

  /// `{count} item`
  String countProduct(Object count) {
    return Intl.message(
      '$count item',
      name: 'countProduct',
      desc: '',
      args: [count],
    );
  }

  /// `{count} items`
  String countProducts(Object count) {
    return Intl.message(
      '$count items',
      name: 'countProducts',
      desc: '',
      args: [count],
    );
  }

  /// `Bluetooth Adapter is {state}`
  String bleState(Object state) {
    return Intl.message(
      'Bluetooth Adapter is $state',
      name: 'bleState',
      desc: '',
      args: [state],
    );
  }

  /// `Printer`
  String get printer {
    return Intl.message('Printer', name: 'printer', desc: '', args: []);
  }

  /// `Change Printer`
  String get changePrinter {
    return Intl.message(
      'Change Printer',
      name: 'changePrinter',
      desc: '',
      args: [],
    );
  }

  /// `Select Printer`
  String get selectPrinter {
    return Intl.message(
      'Select Printer',
      name: 'selectPrinter',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth has not been enabled`
  String get bleHasNotBeenEnabled {
    return Intl.message(
      'Bluetooth has not been enabled',
      name: 'bleHasNotBeenEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Attribute already exists`
  String get attributeAlreadyExists {
    return Intl.message(
      'Attribute already exists',
      name: 'attributeAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Delete all`
  String get deleteAll {
    return Intl.message('Delete all', name: 'deleteAll', desc: '', args: []);
  }

  /// `Create all variants`
  String get createVariants {
    return Intl.message(
      'Create all variants',
      name: 'createVariants',
      desc: '',
      args: [],
    );
  }

  /// `Any {attribute}`
  String anyAttr(Object attribute) {
    return Intl.message(
      'Any $attribute',
      name: 'anyAttr',
      desc: '',
      args: [attribute],
    );
  }

  /// `New variation`
  String get newVariation {
    return Intl.message(
      'New variation',
      name: 'newVariation',
      desc: '',
      args: [],
    );
  }

  /// `Your product is under review`
  String get yourProductIsUnderReview {
    return Intl.message(
      'Your product is under review',
      name: 'yourProductIsUnderReview',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmation`
  String get orderConfirmation {
    return Intl.message(
      'Order Confirmation',
      name: 'orderConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to create the order?`
  String get orderConfirmationMsg {
    return Intl.message(
      'Are you sure you want to create the order?',
      name: 'orderConfirmationMsg',
      desc: '',
      args: [],
    );
  }

  /// `This product is not supported`
  String get thisProductNotSupport {
    return Intl.message(
      'This product is not supported',
      name: 'thisProductNotSupport',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least 1 option for each active attribute`
  String get pleaseSelectAttr {
    return Intl.message(
      'Please select at least 1 option for each active attribute',
      name: 'pleaseSelectAttr',
      desc: '',
      args: [],
    );
  }

  /// `Your application is under review.`
  String get yourApplicationIsUnderReview {
    return Intl.message(
      'Your application is under review.',
      name: 'yourApplicationIsUnderReview',
      desc: '',
      args: [],
    );
  }

  /// `Chinese (Simplified)`
  String get chineseSimplified {
    return Intl.message(
      'Chinese (Simplified)',
      name: 'chineseSimplified',
      desc: '',
      args: [],
    );
  }

  /// `Chinese (Traditional)`
  String get chineseTraditional {
    return Intl.message(
      'Chinese (Traditional)',
      name: 'chineseTraditional',
      desc: '',
      args: [],
    );
  }

  /// `Receiver`
  String get receiver {
    return Intl.message('Receiver', name: 'receiver', desc: '', args: []);
  }

  /// `Burmese`
  String get burmese {
    return Intl.message('Burmese', name: 'burmese', desc: '', args: []);
  }

  /// `Albanian`
  String get albanian {
    return Intl.message('Albanian', name: 'albanian', desc: '', args: []);
  }

  /// `Product type variable needs at least one variant`
  String get productNeedAtLeastOneVariation {
    return Intl.message(
      'Product type variable needs at least one variant',
      name: 'productNeedAtLeastOneVariation',
      desc: '',
      args: [],
    );
  }

  /// `Product type simple needs the name and regular price`
  String get productNeedNameAndPrice {
    return Intl.message(
      'Product type simple needs the name and regular price',
      name: 'productNeedNameAndPrice',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message('Sort by', name: 'sortBy', desc: '', args: []);
  }

  /// `Date: Latest`
  String get dateLatest {
    return Intl.message('Date: Latest', name: 'dateLatest', desc: '', args: []);
  }

  /// `Date: Oldest`
  String get dateOldest {
    return Intl.message('Date: Oldest', name: 'dateOldest', desc: '', args: []);
  }

  /// `Price: Low to High`
  String get priceLowToHigh {
    return Intl.message(
      'Price: Low to High',
      name: 'priceLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Price: High to Low`
  String get priceHighToLow {
    return Intl.message(
      'Price: High to Low',
      name: 'priceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Loading link...`
  String get loadingLink {
    return Intl.message(
      'Loading link...',
      name: 'loadingLink',
      desc: '',
      args: [],
    );
  }

  /// `This link is currently unavailable on this site.`
  String get canNotLoadThisLink {
    return Intl.message(
      'This link is currently unavailable on this site.',
      name: 'canNotLoadThisLink',
      desc: '',
      args: [],
    );
  }

  /// `Image Network`
  String get imageNetwork {
    return Intl.message(
      'Image Network',
      name: 'imageNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Paste your image URL`
  String get pasteYourImageUrl {
    return Intl.message(
      'Paste your image URL',
      name: 'pasteYourImageUrl',
      desc: '',
      args: [],
    );
  }

  /// `Use this Image`
  String get useThisImage {
    return Intl.message(
      'Use this Image',
      name: 'useThisImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load image`
  String get failedToLoadImage {
    return Intl.message(
      'Failed to load image',
      name: 'failedToLoadImage',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allow {
    return Intl.message('Allow', name: 'allow', desc: '', args: []);
  }

  /// `Decline`
  String get decline {
    return Intl.message('Decline', name: 'decline', desc: '', args: []);
  }

  /// `Agree`
  String get agree {
    return Intl.message('Agree', name: 'agree', desc: '', args: []);
  }

  /// `Notify latest offers & product availability`
  String get notifyLatestOffer {
    return Intl.message(
      'Notify latest offers & product availability',
      name: 'notifyLatestOffer',
      desc: '',
      args: [],
    );
  }

  /// `We will send you notifications when new products are available or offers are available. You can always turn it off in the settings.`
  String get weWillSendYouNotification {
    return Intl.message(
      'We will send you notifications when new products are available or offers are available. You can always turn it off in the settings.',
      name: 'weWillSendYouNotification',
      desc: '',
      args: [],
    );
  }

  /// `By signing up, you agree to our`
  String get bySignup {
    return Intl.message(
      'By signing up, you agree to our',
      name: 'bySignup',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get areYouSureDeleteAccount {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'areYouSureDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? Please read how account deletion will affect you.`
  String get deleteAccountMsg {
    return Intl.message(
      'Are you sure you want to delete your account? Please read how account deletion will affect you.',
      name: 'deleteAccountMsg',
      desc: '',
      args: [],
    );
  }

  /// `Deleting your account removes personal information from our database.`
  String get accountDeleteDescription {
    return Intl.message(
      'Deleting your account removes personal information from our database.',
      name: 'accountDeleteDescription',
      desc: '',
      args: [],
    );
  }

  /// `Deleting your account will unsubscribe you from all mailing lists.`
  String get emailDeleteDescription {
    return Intl.message(
      'Deleting your account will unsubscribe you from all mailing lists.',
      name: 'emailDeleteDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter {captcha} to confirm:`
  String enterCaptcha(Object captcha) {
    return Intl.message(
      'Enter $captcha to confirm:',
      name: 'enterCaptcha',
      desc: '',
      args: [captcha],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Email Subscription`
  String get emailSubscription {
    return Intl.message(
      'Email Subscription',
      name: 'emailSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Account Deletion`
  String get confirmAccountDeletion {
    return Intl.message(
      'Confirm Account Deletion',
      name: 'confirmAccountDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message('Notice', name: 'notice', desc: '', args: []);
  }

  /// `You need to log in again to apply the update`
  String get needToLoginAgain {
    return Intl.message(
      'You need to log in again to apply the update',
      name: 'needToLoginAgain',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully. Your session has expired.`
  String get deleteAccountSuccess {
    return Intl.message(
      'Account deleted successfully. Your session has expired.',
      name: 'deleteAccountSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please allow access to the camera and gallery`
  String get pleaseAllowAccessCameraGallery {
    return Intl.message(
      'Please allow access to the camera and gallery',
      name: 'pleaseAllowAccessCameraGallery',
      desc: '',
      args: [],
    );
  }

  /// `Failed to assign User`
  String get failToAssign {
    return Intl.message(
      'Failed to assign User',
      name: 'failToAssign',
      desc: '',
      args: [],
    );
  }

  /// `Go back`
  String get goBack {
    return Intl.message('Go back', name: 'goBack', desc: '', args: []);
  }

  /// `Privacy & Terms`
  String get privacyTerms {
    return Intl.message(
      'Privacy & Terms',
      name: 'privacyTerms',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get results {
    return Intl.message('Results', name: 'results', desc: '', args: []);
  }

  /// `Danish`
  String get danish {
    return Intl.message('Danish', name: 'danish', desc: '', args: []);
  }

  /// `Get notified!`
  String get getNotified {
    return Intl.message(
      'Get notified!',
      name: 'getNotified',
      desc: '',
      args: [],
    );
  }

  /// `I'm in`
  String get imIn {
    return Intl.message('I\'m in', name: 'imIn', desc: '', args: []);
  }

  /// `Allow Camera access?`
  String get allowCameraAccess {
    return Intl.message(
      'Allow Camera access?',
      name: 'allowCameraAccess',
      desc: '',
      args: [],
    );
  }

  /// `We need camera access to scan for QR code or Bar code.`
  String get weNeedCameraAccessTo {
    return Intl.message(
      'We need camera access to scan for QR code or Bar code.',
      name: 'weNeedCameraAccessTo',
      desc: '',
      args: [],
    );
  }

  /// `No camera permission has been granted. Please grant it in your device's Settings.`
  String get noCameraPermissionIsGranted {
    return Intl.message(
      'No camera permission has been granted. Please grant it in your device\'s Settings.',
      name: 'noCameraPermissionIsGranted',
      desc: '',
      args: [],
    );
  }

  /// `This identifier will be used to deliver personalized ads to you. \n"Cancel" will limit Advertisement network's ability to deliver relevant ads to you but will not reduce the number of ads you receive.\nBecause the device is restricted, tracking is disabled and the system can't show a request dialog. "Open Settings" and allow the app to track your activity across other companies' apps and websites?`
  String get appTrackingRequest {
    return Intl.message(
      'This identifier will be used to deliver personalized ads to you. \n"Cancel" will limit Advertisement network\'s ability to deliver relevant ads to you but will not reduce the number of ads you receive.\nBecause the device is restricted, tracking is disabled and the system can\'t show a request dialog. "Open Settings" and allow the app to track your activity across other companies\' apps and websites?',
      name: 'appTrackingRequest',
      desc: '',
      args: [],
    );
  }

  /// `App Tracking Transparency`
  String get appTrackingTransparency {
    return Intl.message(
      'App Tracking Transparency',
      name: 'appTrackingTransparency',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get openSettings {
    return Intl.message(
      'Open settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Generating link...`
  String get generatingLink {
    return Intl.message(
      'Generating link...',
      name: 'generatingLink',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Year of Birth`
  String get invalidYearOfBirth {
    return Intl.message(
      'Invalid Year of Birth',
      name: 'invalidYearOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Failed to generate link`
  String get failedToGenerateLink {
    return Intl.message(
      'Failed to generate link',
      name: 'failedToGenerateLink',
      desc: '',
      args: [],
    );
  }

  /// `COD Extra Fee`
  String get codExtraFee {
    return Intl.message(
      'COD Extra Fee',
      name: 'codExtraFee',
      desc: '',
      args: [],
    );
  }

  /// `More from {store}`
  String moreFromStore(Object store) {
    return Intl.message(
      'More from $store',
      name: 'moreFromStore',
      desc: '',
      args: [store],
    );
  }

  /// `Store`
  String get store {
    return Intl.message('Store', name: 'store', desc: '', args: []);
  }

  /// `Changed currency to {currency}`
  String changedCurrencyTo(Object currency) {
    return Intl.message(
      'Changed currency to $currency',
      name: 'changedCurrencyTo',
      desc: '',
      args: [currency],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message('Light Theme', name: 'lightTheme', desc: '', args: []);
  }

  /// `The {fieldName} field is required`
  String theFieldIsRequired(Object fieldName) {
    return Intl.message(
      'The $fieldName field is required',
      name: 'theFieldIsRequired',
      desc: '',
      args: [fieldName],
    );
  }

  /// `You have successfully saved the address to your local file!`
  String get youHaveBeenSaveAddressYourLocal {
    return Intl.message(
      'You have successfully saved the address to your local file!',
      name: 'youHaveBeenSaveAddressYourLocal',
      desc: '',
      args: [],
    );
  }

  /// `Driver Assigned`
  String get driverAssigned {
    return Intl.message(
      'Driver Assigned',
      name: 'driverAssigned',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number to get started.`
  String get enterYourPhone {
    return Intl.message(
      'Enter your phone number to get started.',
      name: 'enterYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get otpVerification {
    return Intl.message(
      'OTP Verification',
      name: 'otpVerification',
      desc: '',
      args: [],
    );
  }

  /// `An authentication code has been sent to`
  String get weSentAnOTPTo {
    return Intl.message(
      'An authentication code has been sent to',
      name: 'weSentAnOTPTo',
      desc: '',
      args: [],
    );
  }

  /// `No shipping options are available. Please ensure your address has been entered correctly, or contact us if you need assistance.`
  String get emptyShippingMsg {
    return Intl.message(
      'No shipping options are available. Please ensure your address has been entered correctly, or contact us if you need assistance.',
      name: 'emptyShippingMsg',
      desc: '',
      args: [],
    );
  }

  /// `Cannot update user info.`
  String get canNotUpdateInfo {
    return Intl.message(
      'Cannot update user info.',
      name: 'canNotUpdateInfo',
      desc: '',
      args: [],
    );
  }

  /// `Cannot create the user.`
  String get canNotCreateUser {
    return Intl.message(
      'Cannot create the user.',
      name: 'canNotCreateUser',
      desc: '',
      args: [],
    );
  }

  /// `The account is pending approval.`
  String get accountIsPendingApproval {
    return Intl.message(
      'The account is pending approval.',
      name: 'accountIsPendingApproval',
      desc: '',
      args: [],
    );
  }

  /// `Under Approval`
  String get accountApprovalTitle {
    return Intl.message(
      'Under Approval',
      name: 'accountApprovalTitle',
      desc: '',
      args: [],
    );
  }

  /// `The username or password is incorrect.`
  String get userNameInCorrect {
    return Intl.message(
      'The username or password is incorrect.',
      name: 'userNameInCorrect',
      desc: '',
      args: [],
    );
  }

  /// `Cannot save the order to the website`
  String get canNotSaveOrder {
    return Intl.message(
      'Cannot save the order to the website',
      name: 'canNotSaveOrder',
      desc: '',
      args: [],
    );
  }

  /// `This tag does not exist`
  String get tagNotExist {
    return Intl.message(
      'This tag does not exist',
      name: 'tagNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Cannot get token information.`
  String get canNotGetToken {
    return Intl.message(
      'Cannot get token information.',
      name: 'canNotGetToken',
      desc: '',
      args: [],
    );
  }

  /// `Cannot get shipping methods`
  String get canNotGetShipping {
    return Intl.message(
      'Cannot get shipping methods',
      name: 'canNotGetShipping',
      desc: '',
      args: [],
    );
  }

  /// `Cannot get payment methods`
  String get canNotGetPayments {
    return Intl.message(
      'Cannot get payment methods',
      name: 'canNotGetPayments',
      desc: '',
      args: [],
    );
  }

  /// `Cannot create order`
  String get canNotCreateOrder {
    return Intl.message(
      'Cannot create order',
      name: 'canNotCreateOrder',
      desc: '',
      args: [],
    );
  }

  /// `Title: A to Z`
  String get titleAToZ {
    return Intl.message('Title: A to Z', name: 'titleAToZ', desc: '', args: []);
  }

  /// `Title: Z to A`
  String get titleZToA {
    return Intl.message('Title: Z to A', name: 'titleZToA', desc: '', args: []);
  }

  /// `Popularity`
  String get popularity {
    return Intl.message('Popularity', name: 'popularity', desc: '', args: []);
  }

  /// `Average Rating`
  String get averageRating {
    return Intl.message(
      'Average Rating',
      name: 'averageRating',
      desc: '',
      args: [],
    );
  }

  /// `Too many failed login attempts. Please try again later.`
  String get tooManyFailedLogin {
    return Intl.message(
      'Too many failed login attempts. Please try again later.',
      name: 'tooManyFailedLogin',
      desc: '',
      args: [],
    );
  }

  /// `View on Google Maps`
  String get viewOnGoogleMaps {
    return Intl.message(
      'View on Google Maps',
      name: 'viewOnGoogleMaps',
      desc: '',
      args: [],
    );
  }

  /// `The SMS code has expired. Please resend the verification code to try again.`
  String get smsCodeExpired {
    return Intl.message(
      'The SMS code has expired. Please resend the verification code to try again.',
      name: 'smsCodeExpired',
      desc: '',
      args: [],
    );
  }

  /// `You need to log in to checkout`
  String get youNeedToLoginCheckout {
    return Intl.message(
      'You need to log in to checkout',
      name: 'youNeedToLoginCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Product Review`
  String get productReview {
    return Intl.message(
      'Product Review',
      name: 'productReview',
      desc: '',
      args: [],
    );
  }

  /// `Active now`
  String get activeNow {
    return Intl.message('Active now', name: 'activeNow', desc: '', args: []);
  }

  /// `Active a long time ago`
  String get activeLongAgo {
    return Intl.message(
      'Active a long time ago',
      name: 'activeLongAgo',
      desc: '',
      args: [],
    );
  }

  /// `Active for {x}`
  String activeFor(Object x) {
    return Intl.message(
      'Active for $x',
      name: 'activeFor',
      desc: '',
      args: [x],
    );
  }

  /// `Typing...`
  String get typing {
    return Intl.message('Typing...', name: 'typing', desc: '', args: []);
  }

  /// `is typing...`
  String get isTyping {
    return Intl.message('is typing...', name: 'isTyping', desc: '', args: []);
  }

  /// `No conversation yet`
  String get noConversation {
    return Intl.message(
      'No conversation yet',
      name: 'noConversation',
      desc: '',
      args: [],
    );
  }

  /// `It will appear when someone starts chatting with you`
  String get noConversationDescription {
    return Intl.message(
      'It will appear when someone starts chatting with you',
      name: 'noConversationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Menu order`
  String get menuOrder {
    return Intl.message('Menu order', name: 'menuOrder', desc: '', args: []);
  }

  /// `Transaction failed`
  String get transactionFailed {
    return Intl.message(
      'Transaction failed',
      name: 'transactionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Apple Pay is not available on this device!`
  String get doesNotSupportApplePay {
    return Intl.message(
      'Apple Pay is not available on this device!',
      name: 'doesNotSupportApplePay',
      desc: '',
      args: [],
    );
  }

  /// `{currency} is not supported`
  String currencyIsNotSupported(Object currency) {
    return Intl.message(
      '$currency is not supported',
      name: 'currencyIsNotSupported',
      desc: '',
      args: [currency],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Failed to load application configuration. Please try again or restart your application.`
  String get failedToLoadAppConfig {
    return Intl.message(
      'Failed to load application configuration. Please try again or restart your application.',
      name: 'failedToLoadAppConfig',
      desc: '',
      args: [],
    );
  }

  /// `Your account is under review. Please contact the administrator if you need any help.`
  String get yourAccountIsUnderReview {
    return Intl.message(
      'Your account is under review. Please contact the administrator if you need any help.',
      name: 'yourAccountIsUnderReview',
      desc: '',
      args: [],
    );
  }

  /// `New content available!`
  String get newAppConfig {
    return Intl.message(
      'New content available!',
      name: 'newAppConfig',
      desc: '',
      args: [],
    );
  }

  /// `Continue to see new content on your app.`
  String get seeNewAppConfig {
    return Intl.message(
      'Continue to see new content on your app.',
      name: 'seeNewAppConfig',
      desc: '',
      args: [],
    );
  }

  /// `Order tracking`
  String get orderTracking {
    return Intl.message(
      'Order tracking',
      name: 'orderTracking',
      desc: '',
      args: [],
    );
  }

  /// `Lock screen and security`
  String get lockScreenAndSecurity {
    return Intl.message(
      'Lock screen and security',
      name: 'lockScreenAndSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprints, Touch ID`
  String get fingerprintsTouchID {
    return Intl.message(
      'Fingerprints, Touch ID',
      name: 'fingerprintsTouchID',
      desc: '',
      args: [],
    );
  }

  /// `Enable for Checkout`
  String get enableForCheckout {
    return Intl.message(
      'Enable for Checkout',
      name: 'enableForCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Enable for Wallet`
  String get enableForWallet {
    return Intl.message(
      'Enable for Wallet',
      name: 'enableForWallet',
      desc: '',
      args: [],
    );
  }

  /// `Enable for Login`
  String get enableForLogin {
    return Intl.message(
      'Enable for Login',
      name: 'enableForLogin',
      desc: '',
      args: [],
    );
  }

  /// `Our bank details`
  String get ourBankDetails {
    return Intl.message(
      'Our bank details',
      name: 'ourBankDetails',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bank {
    return Intl.message('Bank', name: 'bank', desc: '', args: []);
  }

  /// `Account Number`
  String get accountNumber {
    return Intl.message(
      'Account Number',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Sort Code`
  String get sortCode {
    return Intl.message('Sort Code', name: 'sortCode', desc: '', args: []);
  }

  /// `Register as`
  String get registerAs {
    return Intl.message('Register as', name: 'registerAs', desc: '', args: []);
  }

  /// `Vendor`
  String get vendor {
    return Intl.message('Vendor', name: 'vendor', desc: '', args: []);
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Chat GPT`
  String get chatGPT {
    return Intl.message('Chat GPT', name: 'chatGPT', desc: '', args: []);
  }

  /// `Regenerate response`
  String get regenerateResponse {
    return Intl.message(
      'Regenerate response',
      name: 'regenerateResponse',
      desc: '',
      args: [],
    );
  }

  /// `Clear conversation`
  String get clearConversation {
    return Intl.message(
      'Clear conversation',
      name: 'clearConversation',
      desc: '',
      args: [],
    );
  }

  /// `Listening...`
  String get listening {
    return Intl.message('Listening...', name: 'listening', desc: '', args: []);
  }

  /// `Type a message...`
  String get typeAMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeAMessage',
      desc: '',
      args: [],
    );
  }

  /// `Speech not available`
  String get speechNotAvailable {
    return Intl.message(
      'Speech not available',
      name: 'speechNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Tap the mic to talk`
  String get tapTheMicToTalk {
    return Intl.message(
      'Tap the mic to talk',
      name: 'tapTheMicToTalk',
      desc: '',
      args: [],
    );
  }

  /// `Chat with Bot`
  String get chatWithBot {
    return Intl.message(
      'Chat with Bot',
      name: 'chatWithBot',
      desc: '',
      args: [],
    );
  }

  /// `Generate image`
  String get imageGenerate {
    return Intl.message(
      'Generate image',
      name: 'imageGenerate',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this? This action cannot be undone.`
  String get confirmDelete {
    return Intl.message(
      'Are you sure you want to delete this? This action cannot be undone.',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Copied`
  String get copied {
    return Intl.message('Copied', name: 'copied', desc: '', args: []);
  }

  /// `Show More`
  String get showMore {
    return Intl.message('Show More', name: 'showMore', desc: '', args: []);
  }

  /// `Show Less`
  String get showLess {
    return Intl.message('Show Less', name: 'showLess', desc: '', args: []);
  }

  /// `Register as Vendor`
  String get registerAsVendor {
    return Intl.message(
      'Register as Vendor',
      name: 'registerAsVendor',
      desc: '',
      args: [],
    );
  }

  /// `Select Role`
  String get selectRole {
    return Intl.message('Select Role', name: 'selectRole', desc: '', args: []);
  }

  /// `Change language`
  String get changeLanguage {
    return Intl.message(
      'Change language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Which language do you prefer?`
  String get whichLanguageDoYouPrefer {
    return Intl.message(
      'Which language do you prefer?',
      name: 'whichLanguageDoYouPrefer',
      desc: '',
      args: [],
    );
  }

  /// `Call Store Owner`
  String get callToVendor {
    return Intl.message(
      'Call Store Owner',
      name: 'callToVendor',
      desc: '',
      args: [],
    );
  }

  /// `Send SMS to Store Owner`
  String get sendSMStoVendor {
    return Intl.message(
      'Send SMS to Store Owner',
      name: 'sendSMStoVendor',
      desc: '',
      args: [],
    );
  }

  /// `This payment method is not supported`
  String get paymentMethodIsNotSupported {
    return Intl.message(
      'This payment method is not supported',
      name: 'paymentMethodIsNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Welcome {name}`
  String welcomeUser(Object name) {
    return Intl.message(
      'Welcome $name',
      name: 'welcomeUser',
      desc: '',
      args: [name],
    );
  }

  /// `The minimum amount for using this payment is {currency} {amount}`
  String minAmountForPayment(Object currency, Object amount) {
    return Intl.message(
      'The minimum amount for using this payment is $currency $amount',
      name: 'minAmountForPayment',
      desc: '',
      args: [currency, amount],
    );
  }

  /// `The maximum amount for using this payment is {currency} {amount}`
  String maxAmountForPayment(Object currency, Object amount) {
    return Intl.message(
      'The maximum amount for using this payment is $currency $amount',
      name: 'maxAmountForPayment',
      desc: '',
      args: [currency, amount],
    );
  }

  /// `This product is out of stock`
  String get productOutOfStock {
    return Intl.message(
      'This product is out of stock',
      name: 'productOutOfStock',
      desc: '',
      args: [],
    );
  }

  /// `The current quantity is more than the quantity in stock`
  String get quantityProductExceedInStock {
    return Intl.message(
      'The current quantity is more than the quantity in stock',
      name: 'quantityProductExceedInStock',
      desc: '',
      args: [],
    );
  }

  /// `Manage API Key`
  String get manageApiKey {
    return Intl.message(
      'Manage API Key',
      name: 'manageApiKey',
      desc: '',
      args: [],
    );
  }

  /// `Select Store`
  String get selectStore {
    return Intl.message(
      'Select Store',
      name: 'selectStore',
      desc: '',
      args: [],
    );
  }

  /// `{priceRate} = {pointRate} Points`
  String convertPoint(Object priceRate, Object pointRate) {
    return Intl.message(
      '$priceRate = $pointRate Points',
      name: 'convertPoint',
      desc: '',
      args: [priceRate, pointRate],
    );
  }

  /// `Use maximum {maxPointDiscount} Points for a {maxPriceDiscount} discount on this order!`
  String useMaximumPointDiscount(
    Object maxPointDiscount,
    Object maxPriceDiscount,
  ) {
    return Intl.message(
      'Use maximum $maxPointDiscount Points for a $maxPriceDiscount discount on this order!',
      name: 'useMaximumPointDiscount',
      desc: '',
      args: [maxPointDiscount, maxPriceDiscount],
    );
  }

  /// `Sorry, this product is not accessible for your current role.`
  String get noPermissionForCurrentRole {
    return Intl.message(
      'Sorry, this product is not accessible for your current role.',
      name: 'noPermissionForCurrentRole',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, this product cannot be accessed as it has expired.`
  String get productExpired {
    return Intl.message(
      'Sorry, this product cannot be accessed as it has expired.',
      name: 'productExpired',
      desc: '',
      args: [],
    );
  }

  /// `This product is available for users with specific roles.`
  String get noPermissionToViewProduct {
    return Intl.message(
      'This product is available for users with specific roles.',
      name: 'noPermissionToViewProduct',
      desc: '',
      args: [],
    );
  }

  /// `Please log in with the appropriate credentials to access this product or contact us for more information.`
  String get noPermissionToViewProductMsg {
    return Intl.message(
      'Please log in with the appropriate credentials to access this product or contact us for more information.',
      name: 'noPermissionToViewProductMsg',
      desc: '',
      args: [],
    );
  }

  /// `Feature not available`
  String get featureNotAvailable {
    return Intl.message(
      'Feature not available',
      name: 'featureNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Please contact the administrator to approve your registration.`
  String get b2bKingRegisterMsg {
    return Intl.message(
      'Please contact the administrator to approve your registration.',
      name: 'b2bKingRegisterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, we couldn't find any results.`
  String get notFindResult {
    return Intl.message(
      'Sorry, we couldn\'t find any results.',
      name: 'notFindResult',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, this video cannot be played.`
  String get canNotPlayVideo {
    return Intl.message(
      'Sorry, this video cannot be played.',
      name: 'canNotPlayVideo',
      desc: '',
      args: [],
    );
  }

  /// `Become a different role`
  String get becomeDifferentRole {
    return Intl.message(
      'Become a different role',
      name: 'becomeDifferentRole',
      desc: '',
      args: [],
    );
  }

  /// `Become a Vendor`
  String get becomeAVendor {
    return Intl.message(
      'Become a Vendor',
      name: 'becomeAVendor',
      desc: '',
      args: [],
    );
  }

  /// `Become a Delivery`
  String get becomeADelivery {
    return Intl.message(
      'Become a Delivery',
      name: 'becomeADelivery',
      desc: '',
      args: [],
    );
  }

  /// `{country} country is not supported`
  String countryIsNotSupported(Object country) {
    return Intl.message(
      '$country country is not supported',
      name: 'countryIsNotSupported',
      desc: '',
      args: [country],
    );
  }

  /// `Pay {amount}`
  String payWithAmount(Object amount) {
    return Intl.message(
      'Pay $amount',
      name: 'payWithAmount',
      desc: '',
      args: [amount],
    );
  }

  /// `Name on Card`
  String get nameOnCard {
    return Intl.message('Name on Card', name: 'nameOnCard', desc: '', args: []);
  }

  /// `Set up`
  String get setup {
    return Intl.message('Set up', name: 'setup', desc: '', args: []);
  }

  /// `This is customer role`
  String get thisIsCustomerRole {
    return Intl.message(
      'This is customer role',
      name: 'thisIsCustomerRole',
      desc: '',
      args: [],
    );
  }

  /// `This is vendor role`
  String get thisIsVendorRole {
    return Intl.message(
      'This is vendor role',
      name: 'thisIsVendorRole',
      desc: '',
      args: [],
    );
  }

  /// `by`
  String get by {
    return Intl.message('by', name: 'by', desc: '', args: []);
  }

  /// `Author: {author}`
  String byAuthor(Object author) {
    return Intl.message(
      'Author: $author',
      name: 'byAuthor',
      desc: '',
      args: [author],
    );
  }

  /// `PromptPay ID:`
  String get promptPayID {
    return Intl.message(
      'PromptPay ID:',
      name: 'promptPayID',
      desc: '',
      args: [],
    );
  }

  /// `PromptPay Name:`
  String get promptPayName {
    return Intl.message(
      'PromptPay Name:',
      name: 'promptPayName',
      desc: '',
      args: [],
    );
  }

  /// `PromptPay Type:`
  String get promptPayType {
    return Intl.message(
      'PromptPay Type:',
      name: 'promptPayType',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, no videos found.`
  String get noVideoFound {
    return Intl.message(
      'Sorry, no videos found.',
      name: 'noVideoFound',
      desc: '',
      args: [],
    );
  }

  /// `Must be bought in groups of {number}`
  String mustBeBoughtInGroupsOf(Object number) {
    return Intl.message(
      'Must be bought in groups of $number',
      name: 'mustBeBoughtInGroupsOf',
      desc: '',
      args: [number],
    );
  }

  /// `Please increase or decrease the quantity to continue.`
  String get pleaseIncreaseOrDecreaseTheQuantity {
    return Intl.message(
      'Please increase or decrease the quantity to continue.',
      name: 'pleaseIncreaseOrDecreaseTheQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Search by country name or dial code`
  String get searchByCountryNameOrDialCode {
    return Intl.message(
      'Search by country name or dial code',
      name: 'searchByCountryNameOrDialCode',
      desc: '',
      args: [],
    );
  }

  /// `Opening Hours`
  String get openingHours {
    return Intl.message(
      'Opening Hours',
      name: 'openingHours',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Closed`
  String get closed {
    return Intl.message('Closed', name: 'closed', desc: '', args: []);
  }

  /// `Open 24h`
  String get open24Hours {
    return Intl.message('Open 24h', name: 'open24Hours', desc: '', args: []);
  }

  /// `By Appointment Only`
  String get byAppointmentOnly {
    return Intl.message(
      'By Appointment Only',
      name: 'byAppointmentOnly',
      desc: '',
      args: [],
    );
  }

  /// `Save QR Code`
  String get saveQRCode {
    return Intl.message('Save QR Code', name: 'saveQRCode', desc: '', args: []);
  }

  /// `QR code has been saved successfully.`
  String get qRCodeMsgSuccess {
    return Intl.message(
      'QR code has been saved successfully.',
      name: 'qRCodeMsgSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to Save QR Code`
  String get qRCodeSaveFailure {
    return Intl.message(
      'Failed to Save QR Code',
      name: 'qRCodeSaveFailure',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message('Mobile', name: 'mobile', desc: '', args: []);
  }

  /// `Fax`
  String get fax {
    return Intl.message('Fax', name: 'fax', desc: '', args: []);
  }

  /// `Website`
  String get website {
    return Intl.message('Website', name: 'website', desc: '', args: []);
  }

  /// `Enter address / city`
  String get storeLocatorSearchPlaceholder {
    return Intl.message(
      'Enter address / city',
      name: 'storeLocatorSearchPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Oops! No results match your search criteria`
  String get searchEmptyDataMessage {
    return Intl.message(
      'Oops! No results match your search criteria',
      name: 'searchEmptyDataMessage',
      desc: '',
      args: [],
    );
  }

  /// `Product name cannot be empty`
  String get productNameCanNotEmpty {
    return Intl.message(
      'Product name cannot be empty',
      name: 'productNameCanNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Add to quote request`
  String get addToQuoteRequest {
    return Intl.message(
      'Add to quote request',
      name: 'addToQuoteRequest',
      desc: '',
      args: [],
    );
  }

  /// `Information Table`
  String get informationTable {
    return Intl.message(
      'Information Table',
      name: 'informationTable',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal`
  String get withdrawal {
    return Intl.message('Withdrawal', name: 'withdrawal', desc: '', args: []);
  }

  /// `Your session has expired. Please login again to continue.`
  String get sessionExpired {
    return Intl.message(
      'Your session has expired. Please login again to continue.',
      name: 'sessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Request`
  String get withdrawRequest {
    return Intl.message(
      'Withdraw Request',
      name: 'withdrawRequest',
      desc: '',
      args: [],
    );
  }

  /// `Approved Requests`
  String get approvedRequests {
    return Intl.message(
      'Approved Requests',
      name: 'approvedRequests',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled Requests`
  String get cancelledRequests {
    return Intl.message(
      'Cancelled Requests',
      name: 'cancelledRequests',
      desc: '',
      args: [],
    );
  }

  /// `Payment Settings`
  String get paymentSettings {
    return Intl.message(
      'Payment Settings',
      name: 'paymentSettings',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `1 to each recipient`
  String get oneEachRecipient {
    return Intl.message(
      '1 to each recipient',
      name: 'oneEachRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Separate multiple email addresses with a comma.`
  String get separateMultipleEmailWithComma {
    return Intl.message(
      'Separate multiple email addresses with a comma.',
      name: 'separateMultipleEmailWithComma',
      desc: '',
      args: [],
    );
  }

  /// `Enter an email address for each recipient`
  String get enterEmailEachRecipient {
    return Intl.message(
      'Enter an email address for each recipient',
      name: 'enterEmailEachRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Add a message`
  String get addMessage {
    return Intl.message(
      'Add a message',
      name: 'addMessage',
      desc: '',
      args: [],
    );
  }

  /// `optional`
  String get optional {
    return Intl.message('optional', name: 'optional', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get branch {
    return Intl.message('Branch', name: 'branch', desc: '', args: []);
  }

  /// `Choose the branch`
  String get chooseBranch {
    return Intl.message(
      'Choose the branch',
      name: 'chooseBranch',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a branch`
  String get pleaseChooseBranch {
    return Intl.message(
      'Please choose a branch',
      name: 'pleaseChooseBranch',
      desc: '',
      args: [],
    );
  }

  /// `{number} characters remaining`
  String characterRemain(Object number) {
    return Intl.message(
      '$number characters remaining',
      name: 'characterRemain',
      desc: '',
      args: [number],
    );
  }

  /// `© 2024 InspireUI All rights reserved.`
  String get copyright {
    return Intl.message(
      '© 2024 InspireUI All rights reserved.',
      name: 'copyright',
      desc: '',
      args: [],
    );
  }

  /// `The Password field is required`
  String get passwordIsRequired {
    return Intl.message(
      'The Password field is required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The Confirm password field is required`
  String get confirmPasswordIsRequired {
    return Intl.message(
      'The Confirm password field is required',
      name: 'confirmPasswordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you haven't made any bookings yet. \nStart exploring and make your first booking!`
  String get emptyBookingHistoryMsg {
    return Intl.message(
      'Looks like you haven\'t made any bookings yet. \nStart exploring and make your first booking!',
      name: 'emptyBookingHistoryMsg',
      desc: '',
      args: [],
    );
  }

  /// `{name} have been added to cart successfully`
  String productAddToCart(Object name) {
    return Intl.message(
      '$name have been added to cart successfully',
      name: 'productAddToCart',
      desc: '',
      args: [name],
    );
  }

  /// `Not rated`
  String get notRated {
    return Intl.message('Not rated', name: 'notRated', desc: '', args: []);
  }

  /// `Your order is empty`
  String get yourOrderIsEmpty {
    return Intl.message(
      'Your order is empty',
      name: 'yourOrderIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you haven't added any items.\nStart shopping to fill it in.`
  String get yourOrderIsEmptyMsg {
    return Intl.message(
      'Looks like you haven\'t added any items.\nStart shopping to fill it in.',
      name: 'yourOrderIsEmptyMsg',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your review`
  String get createReviewSuccess {
    return Intl.message(
      'Thank you for your review',
      name: 'createReviewSuccess',
      desc: '',
      args: [],
    );
  }

  /// `We truly appreciate your input and value your contribution in helping us improve`
  String get createReviewSuccessMsg {
    return Intl.message(
      'We truly appreciate your input and value your contribution in helping us improve',
      name: 'createReviewSuccessMsg',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit?`
  String get areYouWantToExit {
    return Intl.message(
      'Are you sure you want to exit?',
      name: 'areYouWantToExit',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to leave without submitting your review?`
  String get doYouWantToLeaveWithoutSubmit {
    return Intl.message(
      'Do you want to leave without submitting your review?',
      name: 'doYouWantToLeaveWithoutSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Rate Product`
  String get rateProduct {
    return Intl.message(
      'Rate Product',
      name: 'rateProduct',
      desc: '',
      args: [],
    );
  }

  /// `Upload image`
  String get uploadImage {
    return Intl.message(
      'Upload image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `View detail`
  String get viewDetail {
    return Intl.message('View detail', name: 'viewDetail', desc: '', args: []);
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Terrible`
  String get terrible {
    return Intl.message('Terrible', name: 'terrible', desc: '', args: []);
  }

  /// `Poor`
  String get poor {
    return Intl.message('Poor', name: 'poor', desc: '', args: []);
  }

  /// `Fair`
  String get fair {
    return Intl.message('Fair', name: 'fair', desc: '', args: []);
  }

  /// `Good`
  String get good {
    return Intl.message('Good', name: 'good', desc: '', args: []);
  }

  /// `Amazing`
  String get amazing {
    return Intl.message('Amazing', name: 'amazing', desc: '', args: []);
  }

  /// `refunds`
  String get refunds {
    return Intl.message('refunds', name: 'refunds', desc: '', args: []);
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Start your shopping journey with us now`
  String get welcomeRegister {
    return Intl.message(
      'Start your shopping journey with us now',
      name: 'welcomeRegister',
      desc: '',
      args: [],
    );
  }

  /// `View cart`
  String get viewCart {
    return Intl.message('View cart', name: 'viewCart', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Withdraw Amount`
  String get withdrawAmount {
    return Intl.message(
      'Withdraw Amount',
      name: 'withdrawAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment details changed successfully.`
  String get paymentDetailsChangedSuccessfully {
    return Intl.message(
      'Payment details changed successfully.',
      name: 'paymentDetailsChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, no transactions were found!`
  String get noTransactionsMsg {
    return Intl.message(
      'Sorry, no transactions were found!',
      name: 'noTransactionsMsg',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get tag {
    return Intl.message('Tag', name: 'tag', desc: '', args: []);
  }

  /// `Attribute`
  String get attribute {
    return Intl.message('Attribute', name: 'attribute', desc: '', args: []);
  }

  /// `Brands`
  String get brands {
    return Intl.message('Brands', name: 'brands', desc: '', args: []);
  }

  /// `Sorry, the shopping cart will be emptied due to the change of region. We are happy to contact you if you need assistance.`
  String get branchChangeWarning {
    return Intl.message(
      'Sorry, the shopping cart will be emptied due to the change of region. We are happy to contact you if you need assistance.',
      name: 'branchChangeWarning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get areYouSureLogOut {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'areYouSureLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Please login to review`
  String get loginToReview {
    return Intl.message(
      'Please login to review',
      name: 'loginToReview',
      desc: '',
      args: [],
    );
  }

  /// `Size Guide`
  String get sizeGuide {
    return Intl.message('Size Guide', name: 'sizeGuide', desc: '', args: []);
  }

  /// `Mobile Number already in use!`
  String get mobileNumberInUse {
    return Intl.message(
      'Mobile Number already in use!',
      name: 'mobileNumberInUse',
      desc: '',
      args: [],
    );
  }

  /// `Please install the DIGITS: Wordpress Mobile Number Signup and Login plugin`
  String get installDigitsPlugin {
    return Intl.message(
      'Please install the DIGITS: Wordpress Mobile Number Signup and Login plugin',
      name: 'installDigitsPlugin',
      desc: '',
      args: [],
    );
  }

  /// `Email already in use!`
  String get emailAlreadyInUse {
    return Intl.message(
      'Email already in use!',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Username is required`
  String get usernameIsRequired {
    return Intl.message(
      'Username is required',
      name: 'usernameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Country code is required`
  String get countryCodeIsRequired {
    return Intl.message(
      'Country code is required',
      name: 'countryCodeIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Mobile is required`
  String get mobileIsRequired {
    return Intl.message(
      'Mobile is required',
      name: 'mobileIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Username already in use!`
  String get usernameAlreadyInUse {
    return Intl.message(
      'Username already in use!',
      name: 'usernameAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `This account can't delete`
  String get cannotDeleteAccount {
    return Intl.message(
      'This account can\'t delete',
      name: 'cannotDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `The account you want to transfer to (email)`
  String get sendTo {
    return Intl.message(
      'The account you want to transfer to (email)',
      name: 'sendTo',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get enterAmount {
    return Intl.message(
      'Enter amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Received money from {name}`
  String receivedMoneyFrom(Object name) {
    return Intl.message(
      'Received money from $name',
      name: 'receivedMoneyFrom',
      desc: '',
      args: [name],
    );
  }

  /// `You only have {currentBalance} left in your wallet`
  String insufficientBalanceMessage(Object currentBalance) {
    return Intl.message(
      'You only have $currentBalance left in your wallet',
      name: 'insufficientBalanceMessage',
      desc: '',
      args: [currentBalance],
    );
  }

  /// `Transfer money to {name}`
  String transferMoneyTo(Object name) {
    return Intl.message(
      'Transfer money to $name',
      name: 'transferMoneyTo',
      desc: '',
      args: [name],
    );
  }

  /// `Error`
  String get errorTitle {
    return Intl.message('Error', name: 'errorTitle', desc: '', args: []);
  }

  /// `TeraWallet`
  String get teraWallet {
    return Intl.message('TeraWallet', name: 'teraWallet', desc: '', args: []);
  }

  /// `Error on getting post!`
  String get errorOnGettingPost {
    return Intl.message(
      'Error on getting post!',
      name: 'errorOnGettingPost',
      desc: '',
      args: [],
    );
  }

  /// `You have no posts`
  String get youHaveNoPost {
    return Intl.message(
      'You have no posts',
      name: 'youHaveNoPost',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to create Post`
  String get youDontHavePermissionToCreatePost {
    return Intl.message(
      'You don\'t have permission to create Post',
      name: 'youDontHavePermissionToCreatePost',
      desc: '',
      args: [],
    );
  }

  /// `The user is not found`
  String get userNotFound {
    return Intl.message(
      'The user is not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Random`
  String get random {
    return Intl.message('Random', name: 'random', desc: '', args: []);
  }

  /// `Enter your username`
  String get enterYourUsername {
    return Intl.message(
      'Enter your username',
      name: 'enterYourUsername',
      desc: '',
      args: [],
    );
  }

  /// `Username is invalid`
  String get usernameInvalid {
    return Intl.message(
      'Username is invalid',
      name: 'usernameInvalid',
      desc: '',
      args: [],
    );
  }

  /// `E-mail address is invalid`
  String get emailAddressInvalid {
    return Intl.message(
      'E-mail address is invalid',
      name: 'emailAddressInvalid',
      desc: '',
      args: [],
    );
  }

  /// `No payment methods are available.`
  String get noPaymentMethodsAvailable {
    return Intl.message(
      'No payment methods are available.',
      name: 'noPaymentMethodsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No Comments`
  String get noComments {
    return Intl.message('No Comments', name: 'noComments', desc: '', args: []);
  }

  /// `Free`
  String get free {
    return Intl.message('Free', name: 'free', desc: '', args: []);
  }

  /// `Delete conversation`
  String get deleteConversation {
    return Intl.message(
      'Delete conversation',
      name: 'deleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Need help?`
  String get needHelp {
    return Intl.message('Need help?', name: 'needHelp', desc: '', args: []);
  }

  /// `Block user`
  String get blockUser {
    return Intl.message('Block user', name: 'blockUser', desc: '', args: []);
  }

  /// `Unblock user`
  String get unblockUser {
    return Intl.message(
      'Unblock user',
      name: 'unblockUser',
      desc: '',
      args: [],
    );
  }

  /// `User has been blocked`
  String get userHasBeenBlocked {
    return Intl.message(
      'User has been blocked',
      name: 'userHasBeenBlocked',
      desc: '',
      args: [],
    );
  }

  /// `You can't send messages to this user`
  String get cannotSendMessage {
    return Intl.message(
      'You can\'t send messages to this user',
      name: 'cannotSendMessage',
      desc: '',
      args: [],
    );
  }

  /// `You won't be able to send and receive messages from this user.`
  String get willNotSendAndReceiveMessage {
    return Intl.message(
      'You won\'t be able to send and receive messages from this user.',
      name: 'willNotSendAndReceiveMessage',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to unblock this user?`
  String get doYouWantToUnblock {
    return Intl.message(
      'Do you want to unblock this user?',
      name: 'doYouWantToUnblock',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Unblock`
  String get unblock {
    return Intl.message('Unblock', name: 'unblock', desc: '', args: []);
  }

  /// `This is delivery role`
  String get thisIsDeliveryrRole {
    return Intl.message(
      'This is delivery role',
      name: 'thisIsDeliveryrRole',
      desc: '',
      args: [],
    );
  }

  /// `Error: {message}`
  String error(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'error',
      desc: '',
      args: [message],
    );
  }

  /// `Transaction failed`
  String get transactionFailded {
    return Intl.message(
      'Transaction failed',
      name: 'transactionFailded',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waiting {
    return Intl.message('Waiting', name: 'waiting', desc: '', args: []);
  }

  /// `{name}: {formattedPrice}`
  String menuServiceItems(Object name, Object formattedPrice) {
    return Intl.message(
      '$name: $formattedPrice',
      name: 'menuServiceItems',
      desc: '',
      args: [name, formattedPrice],
    );
  }

  /// `Multiple Sellers Detected`
  String get multipleSellersDetected {
    return Intl.message(
      'Multiple Sellers Detected',
      name: 'multipleSellersDetected',
      desc: '',
      args: [],
    );
  }

  /// `You're trying to add a product from a new seller to your cart. Please note that you can only purchase from one seller at a time.`
  String get multipleSellersDetectedAndDisableMultiVendorCheckoutContent {
    return Intl.message(
      'You\'re trying to add a product from a new seller to your cart. Please note that you can only purchase from one seller at a time.',
      name: 'multipleSellersDetectedAndDisableMultiVendorCheckoutContent',
      desc: '',
      args: [],
    );
  }

  /// `You're trying to add a product from a new seller to your cart. Do you want to continue?`
  String get multipleSellersDetectedAndEnableMultiVendorCheckoutContent {
    return Intl.message(
      'You\'re trying to add a product from a new seller to your cart. Do you want to continue?',
      name: 'multipleSellersDetectedAndEnableMultiVendorCheckoutContent',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cart and Add New`
  String get clearCartAndAddNew {
    return Intl.message(
      'Clear Cart and Add New',
      name: 'clearCartAndAddNew',
      desc: '',
      args: [],
    );
  }

  /// `My Rating`
  String get myRating {
    return Intl.message('My Rating', name: 'myRating', desc: '', args: []);
  }

  /// `To Rate`
  String get toRate {
    return Intl.message('To Rate', name: 'toRate', desc: '', args: []);
  }

  /// `My Reviews`
  String get myReviews {
    return Intl.message('My Reviews', name: 'myReviews', desc: '', args: []);
  }

  /// `Pending Reviews`
  String get pendingReviews {
    return Intl.message(
      'Pending Reviews',
      name: 'pendingReviews',
      desc: '',
      args: [],
    );
  }

  /// `Login Required`
  String get loginRequired {
    return Intl.message(
      'Login Required',
      name: 'loginRequired',
      desc: '',
      args: [],
    );
  }

  /// `Share Product Data`
  String get shareProductData {
    return Intl.message(
      'Share Product Data',
      name: 'shareProductData',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message('Images', name: 'images', desc: '', args: []);
  }

  /// `Downloading images...`
  String get downloadingImages {
    return Intl.message(
      'Downloading images...',
      name: 'downloadingImages',
      desc: '',
      args: [],
    );
  }

  /// `Share Product Link`
  String get shareProductLink {
    return Intl.message(
      'Share Product Link',
      name: 'shareProductLink',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Wishlist`
  String get removeWishlist {
    return Intl.message(
      'Remove from Wishlist',
      name: 'removeWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to remove {count} item(s) from your wishlist?`
  String removeWishlistContent(Object count) {
    return Intl.message(
      'Do you want to remove $count item(s) from your wishlist?',
      name: 'removeWishlistContent',
      desc: '',
      args: [count],
    );
  }

  /// `Select item`
  String get selectItem {
    return Intl.message('Select item', name: 'selectItem', desc: '', args: []);
  }

  /// `You are selecting {count} item(s)`
  String youAreSelecting(Object count) {
    return Intl.message(
      'You are selecting $count item(s)',
      name: 'youAreSelecting',
      desc: '',
      args: [count],
    );
  }

  /// `Continue to select item`
  String get continueToSelectItem {
    return Intl.message(
      'Continue to select item',
      name: 'continueToSelectItem',
      desc: '',
      args: [],
    );
  }

  /// `{fieldName} cannot be empty.`
  String cannotBeEmpty(Object fieldName) {
    return Intl.message(
      '$fieldName cannot be empty.',
      name: 'cannotBeEmpty',
      desc: '',
      args: [fieldName],
    );
  }

  /// `{fieldName} length must not be less than 3.`
  String cannotLessThreeLength(Object fieldName) {
    return Intl.message(
      '$fieldName length must not be less than 3.',
      name: 'cannotLessThreeLength',
      desc: '',
      args: [fieldName],
    );
  }

  /// `Select Type`
  String get selectType {
    return Intl.message('Select Type', name: 'selectType', desc: '', args: []);
  }

  /// `Add Point`
  String get addPoint {
    return Intl.message('Add Point', name: 'addPoint', desc: '', args: []);
  }

  /// `Use Point`
  String get usePoint {
    return Intl.message('Use Point', name: 'usePoint', desc: '', args: []);
  }

  /// `Enter price`
  String get enterPrice {
    return Intl.message('Enter price', name: 'enterPrice', desc: '', args: []);
  }

  /// `Enter point`
  String get enterPoint {
    return Intl.message('Enter point', name: 'enterPoint', desc: '', args: []);
  }

  /// `Enter description`
  String get enterDescription {
    return Intl.message(
      'Enter description',
      name: 'enterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add {amount} points`
  String addAmountPoints(Object amount) {
    return Intl.message(
      'Add $amount points',
      name: 'addAmountPoints',
      desc: '',
      args: [amount],
    );
  }

  /// `Use {amount} points`
  String useAmountPoints(Object amount) {
    return Intl.message(
      'Use $amount points',
      name: 'useAmountPoints',
      desc: '',
      args: [amount],
    );
  }

  /// `Total points`
  String get totalPoints {
    return Intl.message(
      'Total points',
      name: 'totalPoints',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scanQRCode {
    return Intl.message('Scan QR Code', name: 'scanQRCode', desc: '', args: []);
  }

  /// `Congratulations! Points have been successfully added or redeemed.`
  String get addOrUsePointsSuccessMsg {
    return Intl.message(
      'Congratulations! Points have been successfully added or redeemed.',
      name: 'addOrUsePointsSuccessMsg',
      desc: '',
      args: [],
    );
  }

  /// `Successful`
  String get successful {
    return Intl.message('Successful', name: 'successful', desc: '', args: []);
  }

  /// `Scan Points`
  String get scanPoints {
    return Intl.message('Scan Points', name: 'scanPoints', desc: '', args: []);
  }

  /// `List`
  String get list {
    return Intl.message('List', name: 'list', desc: '', args: []);
  }

  /// `Columns`
  String get columns {
    return Intl.message('Columns', name: 'columns', desc: '', args: []);
  }

  /// `Card`
  String get card {
    return Intl.message('Card', name: 'card', desc: '', args: []);
  }

  /// `Horizontal`
  String get horizontal {
    return Intl.message('Horizontal', name: 'horizontal', desc: '', args: []);
  }

  /// `List Tile`
  String get listTile {
    return Intl.message('List Tile', name: 'listTile', desc: '', args: []);
  }

  /// `Simple List`
  String get simpleList {
    return Intl.message('Simple List', name: 'simpleList', desc: '', args: []);
  }

  /// `Version {number}`
  String version(Object number) {
    return Intl.message(
      'Version $number',
      name: 'version',
      desc: '',
      args: [number],
    );
  }

  /// `Phone number is not registered!`
  String get mobileNumberIsNotRegistered {
    return Intl.message(
      'Phone number is not registered!',
      name: 'mobileNumberIsNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Remaining amount to pay upon delivery`
  String get remainingAmountCod {
    return Intl.message(
      'Remaining amount to pay upon delivery',
      name: 'remainingAmountCod',
      desc: '',
      args: [],
    );
  }

  /// `Advance payment`
  String get advancePayment {
    return Intl.message(
      'Advance payment',
      name: 'advancePayment',
      desc: '',
      args: [],
    );
  }

  /// `Advance amount`
  String get advanceAmount {
    return Intl.message(
      'Advance amount',
      name: 'advanceAmount',
      desc: '',
      args: [],
    );
  }

  /// `Total amount`
  String get totalAmount {
    return Intl.message(
      'Total amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please add the title`
  String get titleFirst {
    return Intl.message(
      'Please add the title',
      name: 'titleFirst',
      desc: '',
      args: [],
    );
  }

  /// `Write your title`
  String get writeTitle {
    return Intl.message(
      'Write your title',
      name: 'writeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please contact the administrator to approve your registration.`
  String get wholesaleRegisterMsg {
    return Intl.message(
      'Please contact the administrator to approve your registration.',
      name: 'wholesaleRegisterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'pullToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get releaseToRefresh {
    return Intl.message(
      'Release to refresh',
      name: 'releaseToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get refreshing {
    return Intl.message(
      'Refreshing...',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Refresh completed`
  String get refreshCompleted {
    return Intl.message(
      'Refresh completed',
      name: 'refreshCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Pull up to load more`
  String get pullUpLoad {
    return Intl.message(
      'Pull up to load more',
      name: 'pullUpLoad',
      desc: '',
      args: [],
    );
  }

  /// `Load failed!`
  String get loadFailed {
    return Intl.message('Load failed!', name: 'loadFailed', desc: '', args: []);
  }

  /// `Bronze Priority`
  String get bronzePriority {
    return Intl.message(
      'Bronze Priority',
      name: 'bronzePriority',
      desc: '',
      args: [],
    );
  }

  /// `Silver Priority`
  String get silverPriority {
    return Intl.message(
      'Silver Priority',
      name: 'silverPriority',
      desc: '',
      args: [],
    );
  }

  /// `Gold Priority`
  String get goldPriority {
    return Intl.message(
      'Gold Priority',
      name: 'goldPriority',
      desc: '',
      args: [],
    );
  }

  /// `Platinum Priority`
  String get platinumPriority {
    return Intl.message(
      'Platinum Priority',
      name: 'platinumPriority',
      desc: '',
      args: [],
    );
  }

  /// `You have`
  String get youHave {
    return Intl.message('You have', name: 'youHave', desc: '', args: []);
  }

  /// `View point history`
  String get viewPointHistory {
    return Intl.message(
      'View point history',
      name: 'viewPointHistory',
      desc: '',
      args: [],
    );
  }

  /// `Rank details`
  String get rankDetails {
    return Intl.message(
      'Rank details',
      name: 'rankDetails',
      desc: '',
      args: [],
    );
  }

  /// `You are currently a member of this rank`
  String get rankDetailsMsg {
    return Intl.message(
      'You are currently a member of this rank',
      name: 'rankDetailsMsg',
      desc: '',
      args: [],
    );
  }

  /// `Bronze`
  String get bronze {
    return Intl.message('Bronze', name: 'bronze', desc: '', args: []);
  }

  /// `Silver`
  String get silver {
    return Intl.message('Silver', name: 'silver', desc: '', args: []);
  }

  /// `Gold`
  String get gold {
    return Intl.message('Gold', name: 'gold', desc: '', args: []);
  }

  /// `Platinum`
  String get platinum {
    return Intl.message('Platinum', name: 'platinum', desc: '', args: []);
  }

  /// `Point history`
  String get pointHistory {
    return Intl.message(
      'Point history',
      name: 'pointHistory',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message('Received', name: 'received', desc: '', args: []);
  }

  /// `Redeemed`
  String get redeemed {
    return Intl.message('Redeemed', name: 'redeemed', desc: '', args: []);
  }

  /// `Add points`
  String get addPoints {
    return Intl.message('Add points', name: 'addPoints', desc: '', args: []);
  }

  /// `Redeem points`
  String get redeemPoints {
    return Intl.message(
      'Redeem points',
      name: 'redeemPoints',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `Note (optional)`
  String get noteOptional {
    return Intl.message(
      'Note (optional)',
      name: 'noteOptional',
      desc: '',
      args: [],
    );
  }

  /// `Enter your note`
  String get enterYourNote {
    return Intl.message(
      'Enter your note',
      name: 'enterYourNote',
      desc: '',
      args: [],
    );
  }

  /// `Points added successfully`
  String get pointsAddedSuccessfully {
    return Intl.message(
      'Points added successfully',
      name: 'pointsAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Points redeemed successfully`
  String get pointsRedeemedSuccessfully {
    return Intl.message(
      'Points redeemed successfully',
      name: 'pointsRedeemedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Points have been added to the user’s account.`
  String get pointsAddedMsg {
    return Intl.message(
      'Points have been added to the user’s account.',
      name: 'pointsAddedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Points have been redeemed from the user’s account.`
  String get pointsRedeemedMsg {
    return Intl.message(
      'Points have been redeemed from the user’s account.',
      name: 'pointsRedeemedMsg',
      desc: '',
      args: [],
    );
  }

  /// `You're our`
  String get youAreOur {
    return Intl.message('You\'re our', name: 'youAreOur', desc: '', args: []);
  }

  /// `Earn more`
  String get upRankNote1 {
    return Intl.message('Earn more', name: 'upRankNote1', desc: '', args: []);
  }

  /// `points to move up this rank.`
  String get upRankNote2 {
    return Intl.message(
      'points to move up this rank.',
      name: 'upRankNote2',
      desc: '',
      args: [],
    );
  }

  /// `Provide this code to staff to`
  String get myQRCodeNote {
    return Intl.message(
      'Provide this code to staff to',
      name: 'myQRCodeNote',
      desc: '',
      args: [],
    );
  }

  /// `My QRCode`
  String get myQRCode {
    return Intl.message('My QRCode', name: 'myQRCode', desc: '', args: []);
  }

  /// `add`
  String get add {
    return Intl.message('add', name: 'add', desc: '', args: []);
  }

  /// `redeem`
  String get redeem {
    return Intl.message('redeem', name: 'redeem', desc: '', args: []);
  }

  /// `Rewards`
  String get rewards {
    return Intl.message('Rewards', name: 'rewards', desc: '', args: []);
  }

  /// `Benefits`
  String get benefits {
    return Intl.message('Benefits', name: 'benefits', desc: '', args: []);
  }

  /// `Coupons dedicated for you`
  String get couponsDedicatedForYou {
    return Intl.message(
      'Coupons dedicated for you',
      name: 'couponsDedicatedForYou',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `Min transaction: {value}`
  String minTransaction(Object value) {
    return Intl.message(
      'Min transaction: $value',
      name: 'minTransaction',
      desc: '',
      args: [value],
    );
  }

  /// `Valid until: {time}`
  String validUntil(Object time) {
    return Intl.message(
      'Valid until: $time',
      name: 'validUntil',
      desc: '',
      args: [time],
    );
  }

  /// `Claim`
  String get claim {
    return Intl.message('Claim', name: 'claim', desc: '', args: []);
  }

  /// `Claimed`
  String get claimed {
    return Intl.message('Claimed', name: 'claimed', desc: '', args: []);
  }

  /// `You have passed {type}`
  String youHavePassed(Object type) {
    return Intl.message(
      'You have passed $type',
      name: 'youHavePassed',
      desc: '',
      args: [type],
    );
  }

  /// `Loyalty Voucher`
  String get loyaltyVoucher {
    return Intl.message(
      'Loyalty Voucher',
      name: 'loyaltyVoucher',
      desc: '',
      args: [],
    );
  }

  /// `Pick a voucher to apply.`
  String get pickVoucherToApply {
    return Intl.message(
      'Pick a voucher to apply.',
      name: 'pickVoucherToApply',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any coupons.`
  String get youDontHaveAnyCoupons {
    return Intl.message(
      'You don\'t have any coupons.',
      name: 'youDontHaveAnyCoupons',
      desc: '',
      args: [],
    );
  }

  /// `This coupon requires a minimum purchase of {amount}.`
  String minTotalCouponInvalidMsg(Object amount) {
    return Intl.message(
      'This coupon requires a minimum purchase of $amount.',
      name: 'minTotalCouponInvalidMsg',
      desc: '',
      args: [amount],
    );
  }

  /// `My coupons`
  String get myCoupons {
    return Intl.message('My coupons', name: 'myCoupons', desc: '', args: []);
  }

  /// `Redeem rewards`
  String get redeemRewards {
    return Intl.message(
      'Redeem rewards',
      name: 'redeemRewards',
      desc: '',
      args: [],
    );
  }

  /// `How to earn points?`
  String get howToEarnPoints {
    return Intl.message(
      'How to earn points?',
      name: 'howToEarnPoints',
      desc: '',
      args: [],
    );
  }

  /// `Available For Tiers`
  String get availableForTiers {
    return Intl.message(
      'Available For Tiers',
      name: 'availableForTiers',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Spend At Least`
  String get spendAtLeast {
    return Intl.message(
      'Spend At Least',
      name: 'spendAtLeast',
      desc: '',
      args: [],
    );
  }

  /// `Select date`
  String get selectDate {
    return Intl.message('Select date', name: 'selectDate', desc: '', args: []);
  }

  /// `Coupons management`
  String get couponsManagement {
    return Intl.message(
      'Coupons management',
      name: 'couponsManagement',
      desc: '',
      args: [],
    );
  }

  /// `Current bid`
  String get currentBid {
    return Intl.message('Current bid', name: 'currentBid', desc: '', args: []);
  }

  /// `Starting bid`
  String get startingBid {
    return Intl.message(
      'Starting bid',
      name: 'startingBid',
      desc: '',
      args: [],
    );
  }

  /// `Item condition`
  String get itemCondition {
    return Intl.message(
      'Item condition',
      name: 'itemCondition',
      desc: '',
      args: [],
    );
  }

  /// `Auction starts`
  String get auctionStarts {
    return Intl.message(
      'Auction starts',
      name: 'auctionStarts',
      desc: '',
      args: [],
    );
  }

  /// `Auction ends`
  String get auctionEnds {
    return Intl.message(
      'Auction ends',
      name: 'auctionEnds',
      desc: '',
      args: [],
    );
  }

  /// `Bid`
  String get bid {
    return Intl.message('Bid', name: 'bid', desc: '', args: []);
  }

  /// `Buy now for {amount}`
  String buyNowFor(Object amount) {
    return Intl.message(
      'Buy now for $amount',
      name: 'buyNowFor',
      desc: '',
      args: [amount],
    );
  }

  /// `Time left`
  String get timeLeft {
    return Intl.message('Time left', name: 'timeLeft', desc: '', args: []);
  }

  /// `Auction starts in`
  String get auctionStartsIn {
    return Intl.message(
      'Auction starts in',
      name: 'auctionStartsIn',
      desc: '',
      args: [],
    );
  }

  /// `Auction History`
  String get auctionHistory {
    return Intl.message(
      'Auction History',
      name: 'auctionHistory',
      desc: '',
      args: [],
    );
  }

  /// `Auction`
  String get auction {
    return Intl.message('Auction', name: 'auction', desc: '', args: []);
  }

  /// `New`
  String get itemConditionNew {
    return Intl.message('New', name: 'itemConditionNew', desc: '', args: []);
  }

  /// `Used`
  String get used {
    return Intl.message('Used', name: 'used', desc: '', args: []);
  }

  /// `Auction type`
  String get auctionType {
    return Intl.message(
      'Auction type',
      name: 'auctionType',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message('Normal', name: 'normal', desc: '', args: []);
  }

  /// `Reverse`
  String get reverse {
    return Intl.message('Reverse', name: 'reverse', desc: '', args: []);
  }

  /// `Start Price`
  String get startPrice {
    return Intl.message('Start Price', name: 'startPrice', desc: '', args: []);
  }

  /// `Bid increment`
  String get bidIncrement {
    return Intl.message(
      'Bid increment',
      name: 'bidIncrement',
      desc: '',
      args: [],
    );
  }

  /// `Reserve price`
  String get reservePrice {
    return Intl.message(
      'Reserve price',
      name: 'reservePrice',
      desc: '',
      args: [],
    );
  }

  /// `Buy it now price`
  String get buyItNowPrice {
    return Intl.message(
      'Buy it now price',
      name: 'buyItNowPrice',
      desc: '',
      args: [],
    );
  }

  /// `Auction Dates`
  String get auctionDates {
    return Intl.message(
      'Auction Dates',
      name: 'auctionDates',
      desc: '',
      args: [],
    );
  }

  /// `Successfully placed a bid for '{name}'`
  String bidSuccessMessage(Object name) {
    return Intl.message(
      'Successfully placed a bid for \'$name\'',
      name: 'bidSuccessMessage',
      desc: '',
      args: [name],
    );
  }

  /// `Auction Ended`
  String get auctionEnded {
    return Intl.message(
      'Auction Ended',
      name: 'auctionEnded',
      desc: '',
      args: [],
    );
  }

  /// `Winning Bid`
  String get winningBid {
    return Intl.message('Winning Bid', name: 'winningBid', desc: '', args: []);
  }

  /// `This item is sold`
  String get thisItemIsSold {
    return Intl.message(
      'This item is sold',
      name: 'thisItemIsSold',
      desc: '',
      args: [],
    );
  }

  /// `Feature`
  String get feature {
    return Intl.message('Feature', name: 'feature', desc: '', args: []);
  }

  /// `Sorry, appointments cannot start on this day.`
  String get appointmentStartInvalidDay {
    return Intl.message(
      'Sorry, appointments cannot start on this day.',
      name: 'appointmentStartInvalidDay',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is still being processed. Please wait a moment.`
  String get cartNotReadyForCheckout {
    return Intl.message(
      'Your cart is still being processed. Please wait a moment.',
      name: 'cartNotReadyForCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get invalidPhone {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'invalidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid country`
  String get invalidCountry {
    return Intl.message(
      'Please select a valid country',
      name: 'invalidCountry',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid postal code`
  String get invalidPostalCode {
    return Intl.message(
      'Please enter a valid postal code',
      name: 'invalidPostalCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid province/state`
  String get invalidProvince {
    return Intl.message(
      'Please enter a valid province/state',
      name: 'invalidProvince',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid city name`
  String get invalidCity {
    return Intl.message(
      'Please enter a valid city name',
      name: 'invalidCity',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid address`
  String get invalidAddress {
    return Intl.message(
      'Please enter a valid address',
      name: 'invalidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid country code`
  String get invalidCountryCode {
    return Intl.message(
      'Please select a valid country code',
      name: 'invalidCountryCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email format (e.g. example@domain.com)`
  String get invalidEmailFormat {
    return Intl.message(
      'Please enter a valid email format (e.g. example@domain.com)',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number format`
  String get invalidPhoneFormat {
    return Intl.message(
      'Please enter a valid phone number format',
      name: 'invalidPhoneFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid postal code format for your country`
  String get invalidPostalCodeFormat {
    return Intl.message(
      'Please enter a valid postal code format for your country',
      name: 'invalidPostalCodeFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a complete address with street name and number`
  String get invalidAddressFormat {
    return Intl.message(
      'Please enter a complete address with street name and number',
      name: 'invalidAddressFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid city name without special characters`
  String get invalidCityFormat {
    return Intl.message(
      'Please enter a valid city name without special characters',
      name: 'invalidCityFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid province/state name`
  String get invalidProvinceFormat {
    return Intl.message(
      'Please enter a valid province/state name',
      name: 'invalidProvinceFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please select a country from the list`
  String get invalidCountryFormat {
    return Intl.message(
      'Please select a country from the list',
      name: 'invalidCountryFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid country code from the list`
  String get invalidCountryCodeFormat {
    return Intl.message(
      'Please select a valid country code from the list',
      name: 'invalidCountryCodeFormat',
      desc: '',
      args: [],
    );
  }

  /// `Please double check your network`
  String get networkError {
    return Intl.message(
      'Please double check your network',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong when trying to do this action. Please double check`
  String get graphqlError {
    return Intl.message(
      'Something went wrong when trying to do this action. Please double check',
      name: 'graphqlError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, unknown error has been appear`
  String get unknownError {
    return Intl.message(
      'Something went wrong, unknown error has been appear',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Connection timeout. Please try again.`
  String get networkTimeout {
    return Intl.message(
      'Connection timeout. Please try again.',
      name: 'networkTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get networkServerError {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'networkServerError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid data provided. Please check your input.`
  String get graphqlValidationError {
    return Intl.message(
      'Invalid data provided. Please check your input.',
      name: 'graphqlValidationError',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please login again.`
  String get graphqlAuthError {
    return Intl.message(
      'Authentication failed. Please login again.',
      name: 'graphqlAuthError',
      desc: '',
      args: [],
    );
  }

  /// `You do not have permission to perform this action.`
  String get graphqlAuthzError {
    return Intl.message(
      'You do not have permission to perform this action.',
      name: 'graphqlAuthzError',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again.`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred. Please try again.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `System error. Please contact support.`
  String get systemError {
    return Intl.message(
      'System error. Please contact support.',
      name: 'systemError',
      desc: '',
      args: [],
    );
  }

  /// `Cart is not available. Please add some items to your cart.`
  String get cartNotAvailable {
    return Intl.message(
      'Cart is not available. Please add some items to your cart.',
      name: 'cartNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Login with Shopify Customer Account`
  String get shopifyCustomerAccountLoginTitle {
    return Intl.message(
      'Login with Shopify Customer Account',
      name: 'shopifyCustomerAccountLoginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use your Shopify account to login and access your orders, addresses, and more.`
  String get shopifyCustomerAccountLoginDescription {
    return Intl.message(
      'Use your Shopify account to login and access your orders, addresses, and more.',
      name: 'shopifyCustomerAccountLoginDescription',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Shopify`
  String get continueWithShopify {
    return Intl.message(
      'Continue with Shopify',
      name: 'continueWithShopify',
      desc: '',
      args: [],
    );
  }

  /// `Logout successfully`
  String get logoutSuccess {
    return Intl.message(
      'Logout successfully',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Logout failed`
  String get logoutFailed {
    return Intl.message(
      'Logout failed',
      name: 'logoutFailed',
      desc: '',
      args: [],
    );
  }

  /// `Update user failed`
  String get updateUserFailed {
    return Intl.message(
      'Update user failed',
      name: 'updateUserFailed',
      desc: '',
      args: [],
    );
  }

  /// `QR Scanner only supports product search`
  String get scannerOnlyForProduct {
    return Intl.message(
      'QR Scanner only supports product search',
      name: 'scannerOnlyForProduct',
      desc: '',
      args: [],
    );
  }

  /// `Invalid QR code`
  String get invalidQRCode {
    return Intl.message(
      'Invalid QR code',
      name: 'invalidQRCode',
      desc: '',
      args: [],
    );
  }

  /// `The scanned QR code is not valid. Please check and try again.`
  String get invalidQRCodeMsg {
    return Intl.message(
      'The scanned QR code is not valid. Please check and try again.',
      name: 'invalidQRCodeMsg',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message('Try again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Amount exceeds available points`
  String get amountExceedsAvailablePoints {
    return Intl.message(
      'Amount exceeds available points',
      name: 'amountExceedsAvailablePoints',
      desc: '',
      args: [],
    );
  }

  /// `Minimum order amount for {storeName} is {minOrderAmount}. Please add few more items from this store!`
  String minOrderAmount(Object storeName, Object minOrderAmount) {
    return Intl.message(
      'Minimum order amount for $storeName is $minOrderAmount. Please add few more items from this store!',
      name: 'minOrderAmount',
      desc: '',
      args: [storeName, minOrderAmount],
    );
  }

  /// `Unnamed location`
  String get unnamedLocation {
    return Intl.message(
      'Unnamed location',
      name: 'unnamedLocation',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotification {
    return Intl.message(
      'No notifications yet',
      name: 'noNotification',
      desc: '',
      args: [],
    );
  }

  /// `No pending orders to deliver`
  String get noPendingDeliveryOrder {
    return Intl.message(
      'No pending orders to deliver',
      name: 'noPendingDeliveryOrder',
      desc: '',
      args: [],
    );
  }

  /// `Comment Failed!`
  String get commentFailed {
    return Intl.message(
      'Comment Failed!',
      name: 'commentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Rental`
  String get rental {
    return Intl.message('Rental', name: 'rental', desc: '', args: []);
  }

  /// `Event`
  String get event {
    return Intl.message('Event', name: 'event', desc: '', args: []);
  }

  /// `Service`
  String get service {
    return Intl.message('Service', name: 'service', desc: '', args: []);
  }

  /// `Classifieds`
  String get classifieds {
    return Intl.message('Classifieds', name: 'classifieds', desc: '', args: []);
  }

  /// `Owner`
  String get owner {
    return Intl.message('Owner', name: 'owner', desc: '', args: []);
  }

  /// `Become an Owner`
  String get becomeAnOwner {
    return Intl.message(
      'Become an Owner',
      name: 'becomeAnOwner',
      desc: '',
      args: [],
    );
  }

  /// `This user role allows to make bookings, send private messages to other users and review listings.`
  String get customerRoleDescription {
    return Intl.message(
      'This user role allows to make bookings, send private messages to other users and review listings.',
      name: 'customerRoleDescription',
      desc: '',
      args: [],
    );
  }

  /// `This user role allows to add listings and booking services and manage them. Owners can't review other listings.`
  String get ownerRoleDescription {
    return Intl.message(
      'This user role allows to add listings and booking services and manage them. Owners can\'t review other listings.',
      name: 'ownerRoleDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter your review`
  String get enterYourReview {
    return Intl.message(
      'Enter your review',
      name: 'enterYourReview',
      desc: '',
      args: [],
    );
  }

  /// `Share more thoughts on the product to help other buyers.`
  String get enterYourReviewHint {
    return Intl.message(
      'Share more thoughts on the product to help other buyers.',
      name: 'enterYourReviewHint',
      desc: '',
      args: [],
    );
  }

  /// `Your cancel request has been submitted successfully!`
  String get cancelOrderSuccess {
    return Intl.message(
      'Your cancel request has been submitted successfully!',
      name: 'cancelOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `The cancel request was unsuccessful`
  String get cancelOrderFailed {
    return Intl.message(
      'The cancel request was unsuccessful',
      name: 'cancelOrderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this order?`
  String get areYouSureCancelOrder {
    return Intl.message(
      'Are you sure you want to cancel this order?',
      name: 'areYouSureCancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to refund this order?`
  String get areYouSureRefundOrder {
    return Intl.message(
      'Are you sure you want to refund this order?',
      name: 'areYouSureRefundOrder',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'am'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'az'),
      Locale.fromSubtags(languageCode: 'bg'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'bs'),
      Locale.fromSubtags(languageCode: 'ca'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'et'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ka'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'km'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ku'),
      Locale.fromSubtags(languageCode: 'lo'),
      Locale.fromSubtags(languageCode: 'lt'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'no'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'PT'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'si'),
      Locale.fromSubtags(languageCode: 'sk'),
      Locale.fromSubtags(languageCode: 'sq'),
      Locale.fromSubtags(languageCode: 'sr'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'ti'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'uk'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'uz'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
