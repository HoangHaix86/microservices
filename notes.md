# Notes

1. Sử dụng Trivy để scan image định kỳ nhằm phát hiện các vấn đề về lỗ hổng bảo mật của package os hoặc các dependency, tích hợp scan image vào quá trình CI/CD
2. Giảm thiểu các package os nhất trong quá trình build image, có thể chia nhiều stage để build
3. Sử dụng non-root user trong image
4. Không lưu trữ các file, thông tin nhạy cảm trong image

## Monitoring

1. Grafana
2. Prometheus - Victoria Metric - Thanos
