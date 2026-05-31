# Описание агрегатов

Каждый агрегат:

- Имеет единственный **корень агрегата (Aggregate Root)**.
- Управляет своей внутренней согласованностью.
- Публикует доменные события при изменении состояния.
- Изолирован от прямого доступа из других доменов.

## 1. `Patient`

- **Bounded Context**: Пациенты
- **Корень агрегата**: `PatientId`
- **Состав агрегата**:
    - Patient (сам корень)
    - ContactInfo (вложенная сущность)
    - MedicalHistorySummary (значение-объект, только метаданные)

**Важно**: полные медицинские карты и истории болезни **не входят** в этот агрегат — они находятся в защищённом
контексте и недоступны для аналитики.

### Бизнес-инварианты

- Имя, дата рождения и пол обязательны при создании.
- Контактная информация должна содержать хотя бы один способ связи (телефон или email).
- Пациент не может быть удалён — только переведён в статус `Archived`.

### События

- `PatientRegistered`
- `PatientContactUpdated`
- `PatientArchived`

## 2. `MedicalExam`

- **Bounded Context**: Медицинские Исследования
- **Корень агрегата**: `ExamId`
- **Состав агрегата**:
    - Exam (основная сущность)
    - PerformedBy (врач/оператор)
    - DeviceUsed (оборудование)
    - ReportReference (ссылка на файл отчёта)

### Бизнес-инварианты

- Обследование не может быть создано без указания пациента и типа исследования.
- Статус обследования должен проходить строгий жизненный цикл: `Scheduled` → `InProgress` → `Completed`.
- Отчёт не может быть прикреплён к незавершённому обследованию.

### События

- `MedicalExamScheduled`
- `MedicalExamStarted`
- `MedicalExamCompleted`

## 3. `AIDiagnosis`

- **Bounded Context**: ИИ-Анализ
- **Корень агрегата**: `DiagnosisId`
- **Состав агрегата**:
    - Diagnosis (результат ИИ)
    - ModelVersion (метаданные модели)
    - ConfidenceScore (оценка достоверности)
    - Findings (список выявленных аномалий)

### Бизнес-инварианты

- Диагноз может быть сгенерирован только на основе завершённого `MedicalExam`.
- Уровень уверенности (`confidence`) должен быть в диапазоне [0.0, 1.0].
- Версия модели ИИ должна быть валидной и зарегистрированной в реестре моделей.

### События

- `AIDiagnosisGenerated`
- `AIDiagnosisApproved` (если врач утвердил результат)
- `AIDiagnosisRejected` (если врач отклонил результат)

## 4. `TreatmentPlan`

- **Bounded Context**: Лечение
- **Корень агрегата**: `TreatmentId`
- **Состав агрегата**:
    - PlanDetails (цель, сроки)
    - Medications (список препаратов)
    - Procedures (процедуры)
    - AssignedDoctor

### Бизнес-инварианты

- План лечения должен ссылаться на подтверждённый диагноз (может быть ИИ или врачебный).
- Даты начала и окончания должны быть логичными: `startDate ≤ endDate`.
- Все препараты и процедуры должны быть из утверждённого справочника.

### События

- `TreatmentPlanCreated`
- `TreatmentPlanUpdated`

## 5. `CreditApplication`

- **Bounded Context**: Финансы
- **Корень агрегата**: `ApplicationId`
- **Состав агрегата**:
    - Application (основные данные)
    - Applicant (ссылка на `PatientId`)
    - LoanTerms (сумма, срок, цель)
    - StatusHistory (журнал статусов)

### Бизнес-инварианты

- Заявка не может быть подана без подтверждённого `PatientId`.
- Сумма кредита должна быть положительной.
- Жизненный цикл статуса: `Submitted` → `UnderReview` → `Approved` / `Rejected`.
- Нельзя изменить заявку после перехода в `Approved`.

### События

- `CreditApplicationSubmitted`
- `CreditApproved`
- `CreditRejected`

## 6. `Payment`

- **Bounded Context**: Финансы
- **Корень агрегата**: `PaymentId`
- **Состав агрегата**:
    - PaymentDetails (сумма, метод)
    - InvoiceReference
    - ProcessingStatus

### Бизнес-инварианты

- Платёж не может быть создан без привязки к счёту (`InvoiceId`).
- Сумма платежа не может превышать остаток по счёту.
- Статус платежа может меняться только последовательно: `Initiated` → `Processed` → `Confirmed` / `Failed`.

### События

- `PaymentInitiated`
- `PaymentProcessed`
- `PaymentFailed`

## 7. `InventoryItem`

- **Bounded Context**: Инвентарь
- **Корень агрегата**: `ItemId`
- **Состав агрегата**:
    - ItemMetadata (название, категория)
    - StockLevel (текущее количество)
    - ReorderThreshold
    - SupplierInfo

### Бизнес-инварианты

- Уровень запаса не может быть отрицательным.
- Порог перезаказа должен быть больше нуля.
- При достижении уровня ниже порога автоматически генерируется `InventoryLowAlert`.

### События

- `InventoryLevelUpdated`
- `InventoryLowAlert`

## 8. `Employee`

- **Bounded Context**: Персонал
- **Корень агрегата**: `EmployeeId`
- **Состав агрегата**:
    - PersonalData
    - Position & Department
    - EmploymentStatus

### Бизнес-инварианты

- Должность и подразделение обязательны.
- Сотрудник не может быть активным без даты приёма на работу.
- При увольнении статус меняется на `Inactive`, но запись сохраняется.

### События

- `EmployeeOnboarded`
- `EmployeeTransferred`
- `EmployeeOffboarded`
