# Каталог доменных событий

## Формат события

Каждое событие включает:

- **Название** на языке предметной области.
- **Контекст-источник** — Bounded Context, генерирующий событие.
- **Семантика** — краткое описание смысла события.
- **Минимальный контракт** — ключевые поля в JSON-формате.

### 1. `PatientRegistered`

- **Источник**: `Пациенты`
- **Семантика**: Зарегистрирован новый пациент в системе. Событие фиксирует факт создания учётной записи и базовых
  данных.
- **Контракт**:
  ```json
  {
    "patientId": "string",
    "fullName": "string",
    "birthDate": "date",
    "gender": "M|F",
    "createdAt": "datetime",
    "clinicId": "string"
  }
  ```

### 2. `PatientContactUpdated`

- **Источник**: `Пациенты`
- **Семантика**: Контактная информация пациента была обновлена (например, телефон, email).
- **Контракт**:
  ```json
  {
    "patientId": "string",
    "contactType": "phone|email|address",
    "oldValue": "string",
    "newValue": "string",
    "updatedAt": "datetime"
  }
  ```

### 3. `PatientArchived`

- **Источник**: `Пациенты`
- **Семантика**: Пациент переведён в архив (например, умер или отказался от услуг).
- **Контракт**:
  ```json
  {
    "patientId": "string",
    "reason": "string",
    "archivedAt": "datetime",
    "clinicId": "string"
  }
  ```

### 4. `MedicalExamScheduled`

- **Источник**: `Медицинские Исследования`
- **Семантика**: Исследование назначено пациенту — зафиксированы дата, устройство, персонал.
- **Контракт**:
  ```json
  {
    "examId": "string",
    "patientId": "string",
    "examType": "string",
    "scheduledAt": "datetime",
    "deviceId": "string",
    "staffId": "string",
    "clinicId": "string"
  }
  ```

### 5. `MedicalExamStarted`

- **Источник**: `Медицинские Исследования`
- **Семантика**: Начало выполнения медицинского исследования.
- **Контракт**:
  ```json
  {
    "examId": "string",
    "startedAt": "datetime",
    "operatorId": "string"
  }
  ```

### 6. `MedicalExamCompleted`

- **Источник**: `Медицинские Исследования`
- **Семантика**: Проведено медицинское исследование (например, МРТ, рентген). Результаты сохранены и доступны для
  ИИ-анализа.
- **Контракт**:
  ```json
  {
    "examId": "string",
    "patientId": "string",
    "examType": "string",
    "deviceId": "string",
    "performedAt": "datetime",
    "reportUrl": "string"
  }
  ```

### 7. `AIDiagnosisGenerated`

- **Источник**: `ИИ-Анализ`
- **Семантика**: Система искусственного интеллекта завершила анализ медицинских данных и сформировала предварительный
  диагноз.
- **Контракт**:
  ```json
  {
    "diagnosisId": "string",
    "examId": "string",
    "patientId": "string",
    "aiModelVersion": "string",
    "confidence": "float",
    "suggestedDiagnosis": "string",
    "generatedAt": "datetime"
  }
  ```

### 8. `AIDiagnosisApproved`

- **Источник**: `ИИ-Анализ`
- **Семантика**: Диагноз, предложенный ИИ, был подтверждён врачом.
- **Контракт**:
  ```json
  {
    "diagnosisId": "string",
    "approvedBy": "string",
    "approvedAt": "datetime"
  }
  ```

### 9. `AIDiagnosisRejected`

- **Источник**: `ИИ-Анализ`
- **Семантика**: Диагноз, предложенный ИИ, был отклонён врачом.
- **Контракт**:
  ```json
  {
    "diagnosisId": "string",
    "rejectedBy": "string",
    "rejectedAt": "datetime",
    "rejectionReason": "string"
  }
  ```

### 10. `TreatmentPlanCreated`

- **Источник**: `Лечение`
- **Семантика**: Врач утвердил план лечения на основе диагноза. План может включать медикаменты, процедуры и
  реабилитацию.
- **Контракт**:
  ```json
  {
    "treatmentId": "string",
    "patientId": "string",
    "doctorId": "string",
    "diagnosisId": "string",
    "startDate": "date",
    "endDate": "date",
    "medications": ["string"],
    "procedures": ["string"]
  }
  ```

### 11. `TreatmentPlanUpdated`

- **Источник**: `Лечение`
- **Семантика**: План лечения был изменён (например, добавлены новые процедуры или скорректированы сроки).
- **Контракт**:
  ```json
  {
    "treatmentId": "string",
    "updatedFields": ["string"],
    "updatedBy": "string",
    "updatedAt": "datetime"
  }
  ```

### 12. `AssetsReserved`

- **Источник**: `Лечение`
- **Семантика**: Ресурсы (лекарства, оборудование) зарезервированы для выполнения лечения.
- **Контракт**:
  ```json
  {
    "reservationId": "string",
    "treatmentId": "string",
    "items": [
      { "itemId": "string", "quantity": "int" }
    ],
    "reservedAt": "datetime"
  }
  ```

### 13. `CreditApplicationSubmitted`

- **Источник**: `Финансы`
- **Семантика**: Пациент подал заявку на медицинский кредит. Событие запускает процесс проверки и одобрения.
- **Контракт**:
  ```json
  {
    "applicationId": "string",
    "patientId": "string",
    "amount": "decimal",
    "purpose": "string",
    "submittedAt": "datetime",
    "clinicId": "string"
  }
  ```

### 14. `CreditApproved`

- **Источник**: `Финансы`
- **Семантика**: Заявка на кредит одобрена. Финансовый домен готов к выдаче средств.
- **Контракт**:
  ```json
  {
    "applicationId": "string",
    "creditId": "string",
    "approvedAmount": "decimal",
    "interestRate": "float",
    "approvedAt": "datetime"
  }
  ```

### 15. `CreditRejected`

- **Источник**: `Финансы`
- **Семантика**: Заявка на кредит отклонена по результатам проверки.
- **Контракт**:
  ```json
  {
    "applicationId": "string",
    "rejectedAt": "datetime",
    "rejectionReason": "string"
  }
  ```

### 16. `PaymentProcessed`

- **Источник**: `Финансы`
- **Семантика**: Обработка оплаты за медицинские услуги завершена (полностью или частично).
- **Контракт**:
  ```json
  {
    "paymentId": "string",
    "invoiceId": "string",
    "patientId": "string",
    "amount": "decimal",
    "paymentMethod": "card|credit|insurance",
    "processedAt": "datetime"
  }
  ```

### 17. `InventoryLevelUpdated`

- **Источник**: `Инвентарь`
- **Семантика**: Уровень запаса товара был обновлён после операции (приёмка, списание, резервирование).
- **Контракт**:
  ```json
  {
    "itemId": "string",
    "previousStock": "int",
    "currentStock": "int",
    "changeReason": "delivery|usage|adjustment",
    "changedAt": "datetime"
  }
  ```

### 18. `InventoryLowAlert`

- **Источник**: `Инвентарь`
- **Семантика**: Уровень запасов определённого товара (лекарства, расходника) ниже порогового значения.
- **Контракт**:
  ```json
  {
    "itemId": "string",
    "itemName": "string",
    "currentStock": "int",
    "reorderLevel": "int",
    "clinicId": "string",
    "alertedAt": "datetime"
  }
  ```

### 19. `EmployeeOnboarded`

- **Источник**: `Персонал`
- **Семантика**: Новый сотрудник (врач, администратор) принят на работу и зарегистрирован в системе.
- **Контракт**:
  ```json
  {
    "employeeId": "string",
    "fullName": "string",
    "position": "string",
    "department": "string",
    "clinicId": "string",
    "hiredAt": "date"
  }
  ```

### 20. `EmployeeOffboarded`

- **Источник**: `Персонал`
- **Семантика**: Сотрудник уволен, учётная запись деактивирована.
- **Контракт**:
  ```json
  {
    "employeeId": "string",
    "fullName": "string",
    "position": "string",
    "department": "string",
    "offboardedAt": "date",
    "exitReason": "resignation|fired|retired"
  }
  ```

### 21. `RealTimeAnalyticsSnapshot`

- **Источник**: `Аналитика`
- **Семантика**: Агрегированная витрина данных опубликовала снимок ключевых показателей (KPI) за последний интервал.
- **Контракт**:
  ```json
  {
    "snapshotId": "string",
    "timestamp": "datetime",
    "kpiType": "patient_wait_time|revenue|bed_occupancy",
    "value": "float",
    "region": "string"
  }
  ```

### 22. `FraudDetected`

- **Источник**: `Аналитика`
- **Семантика**: Обнаружена подозрительная активность (например, мошенничество с оплатами или доступом).
- **Контракт**:
  ```json
  {
    "alertId": "string",
    "detectedAt": "datetime",
    "suspiciousEventType": "duplicate_payment|unusual_access",
    "confidence": "float",
    "details": "string"
  }
  ```

## Подписчики событий (обобщённо)

| Событие                      | Подписчики                                    |
|------------------------------|-----------------------------------------------|
| `PatientRegistered`          | Финансы, ИИ-Анализ, Отчётность                |
| `PatientContactUpdated`      | Отчётность, Уведомления                       |
| `PatientArchived`            | Отчётность, DWH                               |
| `MedicalExamScheduled`       | ИИ-Анализ (планирование), Отчётность          |
| `MedicalExamStarted`         | Отчётность, Аналитика (тайминги)              |
| `MedicalExamCompleted`       | ИИ-Анализ, Лечение, Отчётность                |
| `AIDiagnosisGenerated`       | Лечение, Отчётность, Финансы                  |
| `AIDiagnosisApproved`        | Лечение, Отчётность                           |
| `AIDiagnosisRejected`        | Отчётность, ИИ-Анализ (обучение модели)       |
| `TreatmentPlanCreated`       | Финансы (кредит), Инвентарь (лекарства)       |
| `TreatmentPlanUpdated`       | Финансы, Инвентарь, Отчётность                |
| `AssetsReserved`             | Инвентарь, Отчётность                         |
| `CreditApplicationSubmitted` | Финансы, Отчётность, BI                       |
| `CreditApproved`             | Лечение, Отчётность, Пациенты (уведомление)   |
| `CreditRejected`             | Пациенты (уведомление), Отчётность            |
| `PaymentProcessed`           | Отчётность, DWH, BI, Медицинские Исследования |
| `InventoryLevelUpdated`      | Отчётность, Аналитика                         |
| `InventoryLowAlert`          | Персонал, Отчётность, Поставщики (в будущем)  |
| `EmployeeOnboarded`          | Отчётность, Финансы (зарплата), IT (доступ)   |
| `EmployeeOffboarded`         | Отчётность, IT (ревок), Финансы               |
| `RealTimeAnalyticsSnapshot`  | BI, Дашборды, Управление                      |
| `FraudDetected`              | Финансы, Безопасность, Уведомления            |
