class Environment {
  static Environment get PRODUCTION => const Environment(
      apiUrl: "https://api.cieloecommerce.cielo.com.br",
      apiQueryUrl: "https://apiquery.cieloecommerce.cielo.com.br",
      OnBoardingUrl: 'https://splitonboarding.braspag.com.br',
      authUrl: 'https://auth.braspag.com.br');
  static Environment get SANDBOX => const Environment(
      apiUrl: "https://apisandbox.cieloecommerce.cielo.com.br",
      apiQueryUrl: "https://apiquerysandbox.cieloecommerce.cielo.com.br",
      OnBoardingUrl: 'https://splitonboardingsandbox.braspag.com.br',
      authUrl: 'https://authsandbox.braspag.com.br');

  final String apiUrl;
  final String apiQueryUrl;
  final String OnBoardingUrl;
  final String authUrl;

  const Environment(
      {this.apiUrl, this.apiQueryUrl, this.OnBoardingUrl, this.authUrl});
}
