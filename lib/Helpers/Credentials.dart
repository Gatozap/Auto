import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class CredentialsProvider {
  CredentialsProvider();

  Future<ServiceAccountCredentials> get _credentials async {
    return ServiceAccountCredentials.fromJson({
                                                "type": "service_account",
                                                "project_id": "novo-boca-a-boca",
                                                "private_key_id": "689da60b96bf2a8e385945694f7cde734ea6341b",
                                                "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3kY6P3ca9jrT/\nhLHwPxH7AwTSuBzdFO/HCzGwdrSaVQIGyr9rxhLUKby0MQUpOaoH1HSh36mTgiT6\nmCDBwcP25H/WqOvSQaqW9c+74KqFlqtZcl8femB4VN/1f57hFZ/iR29lhgNkSxBs\nhvjbc1Mobs+M6AFPcF9S1rrZdeKbWN7kbZ2y35ceNK7OQBs3925MhXR8QN7VC5SU\nllNPOnfrIiIHlI6dBgkAxUsloPtGiqOMr1SBlJsO0lhMFMFAQ10QAqZmptK7qfds\nEwEz+Q0zPBmAs9qDA5i1zCwC4mbe1YctVxg18yH6zASVmJmcjITk+uQBCIS9i5iv\nzohksB7VAgMBAAECggEADz40+llOIXtyKC2aoPp7wb40blL/gpQ0fPC/BYo14QLi\nEjJPxuFBuwBkPQo9BXlWVyQbMz3hVPBfpbdwMOaoIR5ER0zrmB//zF1JDK7ROhqS\ny/ClWXXOAO/7UOVyCfrDtgR8iY+hRHi/OmPS0lY3N4pMDcVOJoyMPdK63Ufes0t/\nrp0Uoer5Ml5qzTPVWEriSNdHX2xQ35MBO6GL9ikJOMUJJi9gD4xWqnTxIBnCY7+r\n4riXDtRi7QV0npxQG9YBNCu/jzk1VQGmxZG3yn1OPeVLMVhrepDzXUR8qdavPu0e\nIdB4HNES/Z45sNWyHReFYSOw3YDENwY7IxZlPqJx2QKBgQDx7JturNM7SMJwwnzh\njZy77dkQ3SFia9fnRDocUTtJzrtXaUonXGZhXGukJjgNba1a9tXSlIVzggQ0U1ah\nE60UlcEyX27xpdvm+uk3YjhS0WbgEi2AO83mOSAiFNfDkEAVND+0zTR3QbasD67E\nX8qUX4yjIgQtbW+KV92PrbtZ7wKBgQDCP8I5m6isHhi23dH4dcBHgSDamocOtxu9\n78tYl/a94QXjxnB+0uduHq03vhMaLvKQQhflHeoY5qL5KSbOaLNmY0EvBQSsAyFW\nkhG7snc2/FbR0PQz8KIVi9OOkldb0nibIzZYV0iaCafFg/duLejeJNniWwknDuOZ\nPf8RgQ+newKBgBzipFhdmEb+1ACEqEaCExG5P26tCHxo5fl+AvY4mLyiS2oPb0Qt\n2yeK0mtiCNVJoCY5TKR9CUYWYwwgWzqWT9ciXlP2YxfFNvFoSgpL1u/EguUEJpym\nB1qSvYx0MqLuCUi+2VBsI/SNSxNWOAbIbTa0BeXAfQEzjNrWzOSH2NPPAoGATzY6\n2M0eIln/kAqyxhQWfdIteJeNPbXzzSeND6qghtvNUA4q77zHfUNrNZEALyw35BXf\nsqHZRaA/k0Vxurg9eCI/gZIVTqPUI35bVuQ28yhBqzv/aXLWVdz4P2pzz1Drt6/L\nSIkHZTFMxiHDc52rGXODmmevOss6itIaQqQToyMCgYEA3HfaZC8po3B9u8FSeSI+\nwYG0Jg37VzKwcvQs+VnksXXdkoCKfn2yUpfrKWvSGa+Kj9g0w57e7f8/hmPJSYzt\nNijj7L72RzhircaUjDMrgZIolqs/1sRhCjPWn2A2Rpzc0K3j5Bfr9OFiGmVQl6/g\nZIpO8VMLFitIJwyez2Cs08M=\n-----END PRIVATE KEY-----\n",
                                                "client_email": "novo-boca-a-boca@appspot.gserviceaccount.com",
                                                "client_id": "112884838572947394939",
                                                "auth_uri": "https://accounts.google.com/o/oauth2/auth",
                                                "token_uri": "https://oauth2.googleapis.com/token",
                                                "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
                                                "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/novo-boca-a-boca%40appspot.gserviceaccount.com"
                                              }
                                              );
  }

  Future<AutoRefreshingAuthClient> get client async {
    AutoRefreshingAuthClient _client = await clientViaServiceAccount(
        await _credentials, [VisionApi.CloudVisionScope]).then((c) => c);
    return _client;
  }
}