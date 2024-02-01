# 0. Sự khởi đầu với Vagrant

## Lời nói đầu

Cập nhật sau ...

## Vagrant là gì?

Là tool để quản lý máy ảo.

## Chuẩn bị

Cài đặt tại Vagrant [đây](https://developer.hashicorp.com/vagrant/install)

Dành cho Ubuntu:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

Cài đặt Virtualbox

```bash
sudo apt install -y virtualbox
```

## Tạo Vagrant boxes

Tại sao phải tạo box, trước đó mình đã thử sử dụng box có sẵn rồi, có hai vắn đề mà mình thấy khó chịu như sau:

- Tải xuống cực chậm
- Cấu hình có sẵn đôi khi không theo ý mình

=> Tạo box của riêng mình luôn cho tiện

1. Yêu cầu

Sử dụng Virtualbox
Tại sao sử dụng:
- open-source
- dễ cấu hình ip

2. Tiến hành

Các bạn tạo một máy ảo như bình thường nhưng có một vài lưu ý sau:



