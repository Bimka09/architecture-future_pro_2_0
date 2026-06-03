# Универсальный Terraform-модуль для управления виртуальными машинами

Универсальный модуль `vm_module` предназначен для создания и управления виртуальными машинами
в Yandex Cloud. Модуль полностью параметризован и может использоваться в разных окружениях: `dev`,
`stage`, `prod` и т.п.

## Структура

```
/Task1Advanced/
├── modules/
│   └── vm/                  # Переиспользуемый модуль ВМ
│       ├── main.tf          # Описание ресурсов (ВМ + диск)
│       ├── variables.tf     # Входные переменные
│       └── outputs.tf       # Выходные данные
└── envs/
    ├── dev/                 # Окружение разработки
    ├── stage/               # Окружение тестирования
    └── prod/                # Боевое окружение
```

Каждое окружение использует общий модуль `vm` и передаёт свои параметры через `.tfvars`-файл.

## Модуль `vm_module` (`/modules/vm/`)

### Параметры (входные переменные)

| Параметр         | Описание                     |
| ---------------- | ---------------------------- |
| `vm_name`        | Имя виртуальной машины       |
| `zone`           | Зона размещения              |
| `platform_id`    | Тип платформы VM             |
| `cores`          | Количество vCPU              |
| `memory`         | Объём RAM                    |
| `image_id`       | ID образа                    |
| `boot_disk_size` | Размер boot-диска            |
| `boot_disk_type` | Тип boot-диска               |
| `disk_size`      | Размер дополнительного диска |
| `disk_type`      | Тип дополнительного диска    |
| `subnet_id`      | ID subnet                    |
| `ssh_user`       | SSH username                 |
| `ssh_key`        | SSH public key               |
| `preemptible`    | Использование preemptible VM |

Все значения окружений вынесены в переменные, внутри модуля нет неизменяемых значений 
(кроме имени платформы и типа диска).

### Выходные данные (outputs)

| Output                 | Описание                  |
| ---------------------- | ------------------------- |
| `vm_id`                | ID виртуальной машины     |
| `vm_name`              | Имя VM                    |
| `internal_ip_address`  | Внутренний IP             |
| `external_ip_address`  | Внешний IP                |
| `fqdn`                 | FQDN VM                   |
| `additional_disk_id`   | ID дополнительного диска  |
| `additional_disk_name` | Имя дополнительного диска |

## Окружения

Модуль используется в трёх окружениях: `dev`, `stage` и `prod`.
Каждое окружение имеет файл `terraform.tfvars` — значения переменных для конкретного окружения

## Как использовать

Инициализация:

```bash
terraform init
```

Планирование:

```bash
terraform plan -var-file=terraform.tfvars
```

Запуск (применение окружения):

```bash
terraform apply -var-file=envs/dev/terraform.tfvars
```

## Пример вывода после применения

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

additional_disk_id = "epd2j6h8asdfgh12345" 
additional_disk_name = "dev-vm-disk" 
external_ip_address = "84.201.154.22" 
fqdn = "dev-vm.ru-central1.internal" 
internal_ip_address = "10.128.0.15" 
vm_id = "fhm87asd9fgh123456" 
vm_name = "dev-vm"
```