import 'package:flux_ui/flux_ui.dart';

import '../constants.dart';
import 'models/review/review_config.dart';
import 'models/review/review_service_type.dart';

/// Validation result for review configuration
class ReviewConfigValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const ReviewConfigValidationResult({
    required this.isValid,
    required this.errors,
    this.warnings = const [],
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
}

/// Validator for review configurations
class ReviewConfigValidator {
  /// Validate a review configuration map
  static ReviewConfigValidationResult validate(Map<String, dynamic> config) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate service type
    if (config['service'] != null) {
      final service = config['service'];
      if (!['native', 'judge'].contains(service)) {
        errors.add(
            'Invalid review service type: $service. Must be "native" or "judge"');
      }

      // Validate Judge.me specific configuration
      if (service == 'judge') {
        final judgeConfig = config['judgeConfig'];
        if (judgeConfig == null) {
          errors.add(
              'Judge.me configuration is required when service is "judge"');
        } else {
          // Validate API key
          if (judgeConfig['apiKey'] == null ||
              judgeConfig['apiKey'].toString().isEmpty) {
            errors.add('Judge.me API key is required');
          }

          // Validate domain
          if (judgeConfig['domain'] == null ||
              judgeConfig['domain'].toString().isEmpty) {
            errors.add('Judge.me domain is required');
          } else {
            final domain = judgeConfig['domain'].toString();
            if (!domain.startsWith('http://') &&
                !domain.startsWith('https://')) {
              warnings.add(
                  'Judge.me domain should include protocol (http:// or https://)');
            }
          }
        }
      }
    }

    // Validate enableReview setting
    if (config['enableReview'] != null && config['enableReview'] is! bool) {
      errors.add('enableReview must be a boolean value');
    }

    // Validate enableReviewImage setting
    if (config['enableReviewImage'] != null &&
        config['enableReviewImage'] is! bool) {
      errors.add('enableReviewImage must be a boolean value');
    }

    // Validate maxImage setting
    if (config['maxImage'] != null) {
      final maxImage = config['maxImage'];
      if (maxImage is! int) {
        errors.add('maxImage must be an integer value');
      } else if (maxImage < 0) {
        errors.add('maxImage must be a positive integer');
      } else if (maxImage > 10) {
        warnings.add(
            'maxImage is set to $maxImage, which might impact performance');
      }
    }

    return ReviewConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate a ReviewConfig object
  static ReviewConfigValidationResult validateReviewConfig(
      ReviewConfig config) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate Judge.me configuration if service is judge
    if (config.service == ReviewServiceType.judge) {
      if (config.judgeConfig.apiKey.isEmpty) {
        errors.add('Judge.me API key is required');
      }

      if (config.judgeConfig.domain.isEmpty) {
        errors.add('Judge.me domain is required');
      } else {
        final domain = config.judgeConfig.domain;
        if (!domain.startsWith('http://') && !domain.startsWith('https://')) {
          warnings.add(
              'Judge.me domain should include protocol (http:// or https://)');
        }
      }
    }

    // Validate maxImage
    if (config.maxImage < 0) {
      errors.add('maxImage must be a positive integer');
    } else if (config.maxImage > 10) {
      warnings.add(
          'maxImage is set to ${config.maxImage}, which might impact performance');
    }

    return ReviewConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate site-specific review configuration
  static ReviewConfigValidationResult validateSiteConfig(
      MultiSiteConfig siteConfig) {
    if (siteConfig.configurations?['reviewConfig'] == null) {
      // No site-specific review config is valid (will use global config)
      return const ReviewConfigValidationResult(isValid: true, errors: []);
    }

    try {
      final reviewConfigMap =
          Map<String, dynamic>.from(siteConfig.configurations!['reviewConfig']);
      return validate(reviewConfigMap);
    } catch (e) {
      return ReviewConfigValidationResult(
        isValid: false,
        errors: ['Invalid review configuration format: $e'],
      );
    }
  }

  /// Log validation results
  static void logValidationResult(
      ReviewConfigValidationResult result, String context) {
    if (result.hasErrors) {
      printLog('❌ Review config validation errors in $context:');
      for (final error in result.errors) {
        printLog('  - $error');
      }
    }

    if (result.hasWarnings) {
      printLog('⚠️ Review config validation warnings in $context:');
      for (final warning in result.warnings) {
        printLog('  - $warning');
      }
    }

    if (result.isValid && !result.hasWarnings) {
      printLog('✅ Review config validation passed for $context');
    }
  }
}
