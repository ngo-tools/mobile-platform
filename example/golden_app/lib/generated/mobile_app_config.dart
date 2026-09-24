// GENERATED FILE. DO NOT EDIT.

import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Public registration-bound application configuration.
final mobileAppConfiguration = MobileAppConfiguration(
  appId: 'mob_01J00000000000000000000000',
  tenant: 'synthetic-demo',
  defaultLocale: 'de',
  locales: ['de', 'en'],
  environments: {
    MobileEnvironment.development: MobileEnvironmentConfiguration(
      environment: MobileEnvironment.development,
      id: 'env_01J00000000000000000000000',
      apiBaseUrl: Uri.parse('https://development.example.invalid/api/v2'),
      configRevision: 'cfg_01J00000000000000000000000',
      attestationMode: MobileAttestationMode.disabled,
      oidc: MobileOidcConfiguration(
        issuer: Uri.parse(
          'https://identity.development.example.invalid/realms/synthetic',
        ),
        clientId: 'mobile-01j00000000000000000000000',
        redirectUri: Uri.parse(
          'ngotools-01j00000000000000000000000://oauth/callback',
        ),
        scopes: ['openid', 'profile', 'email', 'offline_access'],
      ),
    ),
    MobileEnvironment.staging: MobileEnvironmentConfiguration(
      environment: MobileEnvironment.staging,
      id: 'env_01J00000000000000000000001',
      apiBaseUrl: Uri.parse('https://staging.example.invalid/api/v2'),
      configRevision: 'cfg_01J00000000000000000000001',
      attestationMode: MobileAttestationMode.test,
      oidc: MobileOidcConfiguration(
        issuer: Uri.parse(
          'https://identity.staging.example.invalid/realms/synthetic',
        ),
        clientId: 'mobile-01j00000000000000000000001',
        redirectUri: Uri.parse(
          'ngotools-01j00000000000000000000001://oauth/callback',
        ),
        scopes: ['openid', 'profile', 'email', 'offline_access'],
      ),
    ),
    MobileEnvironment.production: MobileEnvironmentConfiguration(
      environment: MobileEnvironment.production,
      id: 'env_01J00000000000000000000002',
      apiBaseUrl: Uri.parse('https://production.example.invalid/api/v2'),
      configRevision: 'cfg_01J00000000000000000000002',
      attestationMode: MobileAttestationMode.enforced,
      oidc: MobileOidcConfiguration(
        issuer: Uri.parse(
          'https://identity.production.example.invalid/realms/synthetic',
        ),
        clientId: 'mobile-01j00000000000000000000002',
        redirectUri: Uri.parse(
          'ngotools-01j00000000000000000000002://oauth/callback',
        ),
        scopes: ['openid', 'profile', 'email', 'offline_access'],
      ),
    ),
  },
);
