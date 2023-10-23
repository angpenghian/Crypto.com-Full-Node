# Cloudfront only deploy after eks cluster is ready, as it need to be pointed to the load balancer

# Fetch the LoadBalancer's DNS name using Kubernetes Service data source
data "kubernetes_service" "crypto_node_service" {
    metadata {
        name      = "crypto-node-service"
        namespace = "default"
    }
}

resource "aws_cloudfront_distribution" "crypto_cloudfront" {
    origin {
        domain_name = data.kubernetes_service.crypto_node_service.load_balancer_ingress[0].hostname # Fetch LoadBalancer's DNS name
        origin_id   = "EKSCryptoNodeLoadBalancer"

        custom_origin_config {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = ["TLSv1.2"]
        }
    }

    enabled             = true
    is_ipv6_enabled     = false
    aliases             = [var.domain]

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "EKSCryptoNodeLoadBalancer"

        viewer_protocol_policy = "redirect-to-https"
        default_ttl = 0
        min_ttl     = 0
        max_ttl     = 0

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    viewer_certificate {
        acm_certificate_arn      = var.certificate_arn2
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2018"
    }

    price_class = "PriceClass_200"
    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations        = ["US", "CA", "GB", "SG"]
        }
    }

    tags = {
        Name = var.environment
    }
}