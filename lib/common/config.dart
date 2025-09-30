import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../common/tools.dart';
import '../data/boxes.dart';
import '../env.dart';
import '../models/entities/loyalty/member_type_enum.dart';
import '../modules/dynamic_layout/index.dart';
import '../services/service_config.dart';
import '../services/services.dart';
import 'config/configuration_utils.dart';
import 'config/loading/index.dart';
import 'config/models/address_field_config.dart';
import 'config/models/app_rating_config.dart';
import 'config/models/branch_config.dart';
import 'config/models/index.dart';
import 'config/models/loyalty_config.dart';
import 'config/models/onboarding_config.dart';
import 'config/models/points_offline_store_config.dart';
import 'config/models/vendor_config.dart';
import 'config/models/wishlist_config.dart';
import 'constants.dart';

part 'config/advertise.dart';
part 'config/blogs.dart';
part 'config/configurations.dart';
part 'config/data_mapping.dart';
part 'config/default_env.dart';
part 'config/dynamic_link.dart';
part 'config/firebase.dart';
part 'config/general.dart';
part 'config/languages.dart';
part 'config/loading.dart';
part 'config/loyalty.dart';
part 'config/onboarding.dart';
part 'config/payments.dart';
part 'config/products.dart';
part 'config/shopify_customer_account.dart';
part 'config/smartchat.dart';
part 'config/vendor.dart';
part 'config/wishlist.dart';

Map get serverConfig => Configurations.serverConfig;
