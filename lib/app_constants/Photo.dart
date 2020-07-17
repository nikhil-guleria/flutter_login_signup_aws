import 'dart:convert';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  String sessionToken;
  int maxFileSize;

  Policy(this.key, this.bucket, this.datetime, this.expiration, this.credential,
      this.maxFileSize, this.sessionToken,
      {this.region = 'us-east-1'});

  factory Policy.fromS3PresignedPost(
      String key,
      String bucket,
      int expiryMinutes,
      String accessKeyId,
      int maxFileSize,
      String sessionToken, {
        String region,
      }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';
    final p = Policy(
        key, bucket, datetime, expiration, cred, maxFileSize, sessionToken,
        region: region);
    return p;
  }

  String encode()
  {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
    { "expiration": "${this.expiration}",
      "conditions": [
     {"bucket": "${this.bucket}"},
     ["starts-with", "\$key", "${this.key}"],
     {"acl": "public-read"},
     ["content-length-range", 1, ${this.maxFileSize}],
     {"x-amz-credential": "${this.credential}"},
     {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
     {"x-amz-date": "${this.datetime}" },
     {"x-amz-security-token": "${this.sessionToken}" }
  ]
}
''';
  }
}