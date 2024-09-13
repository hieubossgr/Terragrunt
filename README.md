## Nội dung tổng quan

1. [Project Overview](#project-overview)
2. [System Structure](#system-structure)
3. [System Workflow](#system-workflow)

## Project Overview

- **Route 53:** Quản lý DNS cho tên miền.
- **Application Load Balancer (ALB):** Định tuyến lưu lượng tới các dịch vụ backend chạy trên ECS.
- **ECS (Elastic Container Service) với Fargate:** Quản lý các ứng dụng container và cron jobs.
- **Aurora RDS:** Cung cấp cơ sở dữ liệu aurora-mysql được quản lý.
- **VPC và Security Groups:** Cung cấp netwrok và security.
- **ECR (Elastic Container Registry):** Lưu trữ image Docker cho các tác vụ ECS.
- **CodeDeploy:** Tự động triển khai ứng dụng lên ECS.
- **S3 và S3 Gateway Endpoint:** Lưu trữ các resource static và cung cấp kết nối riêng tư.
- **IAM Roles and Policies:** Quản lý quyền truy cập cho các dịch vụ AWS.

![Overview Project](https://drive.usercontent.google.com/download?id=171n-kYj-z5F-UMzUL1hp4vY8Zk8tS9_o&export=view)

## System Structure
![Người dùng truy cập](https://drive.usercontent.google.com/download?id=1DErN6roSid-SM5t8NH66Y7yyyPPhX4ym&export=view)


![Developer push/merge code](https://drive.usercontent.google.com/download?id=16UxAoPNE-tGdaTKe1TqLRaf3bFiCi7Or&export=view)


## System workflow

1. **Quản lý tên miền với Route 53**
   - Route 53 được sử dụng để quản lý tên miền và định tuyến DNS.
   - Nó định tuyến các yêu cầu từ người dùng tới ALB cho lớp ứng dụng.

2. **VPC và Security Group**
   - Module VPC tạo ra một môi trường mạng ảo với cả public subnet và private subnet, cho phép phân tách tài nguyên dựa trên nhu cầu truy cập. Các public subnet thường được sử dụng cho ALB, trong khi các private subnet dành cho ECS, RDS và các dịch vụ backend khác.
   - Security group kiểm soát lưu lượng vào và ra giữa các dịch vụ khác nhau, đảm bảo chỉ có lưu lượng được ủy quyền mới được phép giữa các thành phần như ALB, ECS, RDS, và các CronJob.

3. **Application Load Balancer (ALB)**
   - ALB được thiết lập trong các public subnet để xử lý lưu lượng truy cập từ internet.
   - Nó định tuyến các yêu cầu tới các dịch vụ ECS thích hợp dựa trên các quy tắc được định nghĩa trong các listener của ALB.
   - ALB thực hiện các healcheck để đảm bảo rằng lưu lượng chỉ được định tuyến tới các target khỏe mạnh.

4. **ECS và ECR Integration**
   - Module ECS triển khai một cụm ECS trong các private subnet sử dụng kiểu khởi chạy Fargate cho quản lý container không cần máy chủ.
   - Module ECR cung cấp kho lưu trữ Image Docker, nơi các image container được lưu trữ và ECS tasks pull về.
   - Pipeline CI/CD trong CodeDeploy tương tác với ECR để tự động triển khai lên ECS.

5. **Database Service: RDS Aurora**
   - RDS Aurora được triển khai trong các private subnet để đảm bảo cơ sở dữ liệu không thể truy cập trực tiếp từ internet.
   - Chỉ các ECS tasks và CronJob trong các private subnet mới có thể kết nối với cơ sở dữ liệu.

6. **Scheduled Tasks sử dụng Lambda function (CronJob):**
   - Module CronJob sử dụng Lambda để chạy các công việc định kỳ.
   - Các công việc này có thể tương tác với các thành phần khác như cơ sở dữ liệu RDS hoặc kích hoạt các quy trình trong ECS.

7. **Continuous Deployment CodeDeploy**
   - CodeDeploy tự động triển khai lên dịch vụ ECS. Khi các image container mới được đẩy lên ECR
   - CodeDeploy quản lý việc triển khai đảm bảo downtime tối thiểu và auto rollback nếu cần 

8. **S3 and S3 Gateway Endpoint**
   - S3 bucket được sử dụng để lưu trữ nội dung tĩnh hoặc backup
   - S3 gateway endpoint cung cấp kết nối riêng tới bucket S3 từ bên trong VPC mà không đi qua internet.

9. **IAM**
   - Các roles IAM và policies được tạo ra để quản lý quyền truy cập cho các dịch vụ AWS khác nhau.
