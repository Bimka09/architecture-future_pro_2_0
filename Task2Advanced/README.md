# Автоматизированное развёртывание инфраструктуры через CI/CD

Репозиторий реализует управление инфраструктурой в Yandex Cloud с помощью Terraform и GitHub Actions.

## Требования

- Удалённое состояние хранится в **Yandex Object Storage** (S3-совместимый бэкенд).
- Никакие состояния не хранятся локально.
- Все чувствительные данные передаются через секреты GitHub.
- Поддержка окружений: `dev`, `stage`, `prod`.

Для дополнительной степени человеческого контроля:

- Развёртывание в `prod` требует ручного подтверждения.

## Структура

```
/Task2Advanced/ 
├── modules/vm/                      # Переиспользуемый модуль 
├── envs/{dev,stage,prod}/           # Окружения 
├── backend.tf                       # Бэкэнд для хранения состояния (S3) 
├── provider.tf 
└── .github/workflows/terraform.yml  # Пайплайн CI/CD
```

## Бэкэнд

[backend.tf](./backend.tf)

## Подготовка

1. Создайте сервисный аккаунт в Yandex Cloud с правами:
    - `editor` — для управления ресурсами.
    - `storage.admin` — для доступа к Object Storage.
2. Сгенерируйте статические ключи (access/secret) для бэкенда.
3. Сохраните все ключи в **GitHub Secrets**:
    - `YC_TOKEN` — IAM-токен.
    - `YC_CLOUD_ID`, `YC_FOLDER_ID`
    - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
4. Создайте бакет в Yandex Object Storage:

```bash 
   yc storage bucket create --name tf-state-prod-bucket --public-read-object-list=false
```

## Пайплайн CI/CD (GitHub Actions)

[terraform.yml](Task2Advanced/.github/workflows/terraform.yml)

Пайплайн реагирует на пуши в ветки:

| Ветка     | Окружение | Применение                         |
|-----------|-----------|------------------------------------|
| `dev`     | dev       | Автоматически при пуше             |
| `staging` | stage     | Автоматически при пуше             |
| `main`    | prod      | Только после ручного подтверждения |

Все секреты передаются через переменные окружения.

## Безопасность

- Все секреты передаются через переменные окружения.
- Terraform state защищён и не попадает в Git.
- Применение в `prod` контролируется через ручное подтверждение.
