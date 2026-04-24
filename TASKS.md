# Invoicely Project Roadmap & Tasks

## 🚀 Current Focus: Invoice Feature
The "Complex Transaction" phase. Handling data linking, real-time calculations, and state management.

### 🧾 Invoice Feature Tasks
- [x] **I1.1 Item Model**: Define `InvoiceItemModel` as `@Embedded`.
- [x] **I1.2 Invoice Model**: Define `InvoiceModel` with `IsarLink<ClientModel>`.
- [x] **I1.3 Repository**: Implement `IsarInvoiceService` and `InvoiceRepositoryImpl`.
- [x] **I2.1 Controller State**: Implement `InvoiceListState` and `InvoiceFormState`.
- [x] **I2.2 Logic**: Create `InvoiceFormController` for drafting and `InvoiceListController` for viewing.
- [ ] **I2.3 Automatic Overdue Calculation**: 
    - Implement a getter in `InvoiceModel` or an extension to check `if (status != paid && dueDate < now)`.
    - Ensure the `InvoiceListController` filtering logic accounts for this "effective status."
    - Add UI indicators (Red text/icons) for overdue items.
- [x] **I3.1 UI - List Screen**: Build the main list with search and status filter chips.
- [x] **I3.2 UI - Form Screen**: Build client selection modal and product selection logic.
- [x] **I3.3 UI - Calculations**: Ensure totals, tax, and subtotals update reactively in the form.

## 🏠 Core Layout & System
The "Skeleton" of Invoicely. Managing navigation, global settings, and the dashboard.

### 🏠 Home Screen (Dashboard)
- [ ] **H1.1 Summary Cards**: Build horizontal scrolling cards for "Total Revenue," "Pending Invoices," and "Active Clients."
- [ ] **H1.2 Recent Activity**: A list of the last 5 invoices created for quick access.
- [ ] **H1.3 Quick Actions**: Floating Action Button (FAB) or speed-dial for "New Invoice," "New Client," and "New Product."

### ⚙️ Settings Screen
- [ ] **S1.1 Business Profile**: Fields to save user's business name, logo (file path), and tax info (used for PDF generation).
- [ ] **S1.2 Appearance**: Toggle for Dark Mode and primary color theme selection.
- [ ] **S1.3 Data Management**: Buttons for "Backup/Restore" (Isar export) and "Clear All Data."
- [ ] **S1.4 Preferences**: Default tax rate and default currency setting for new invoices.

## 🛠 Planned Features & Backlog

### 🏦 Client Management
- [x] Client CRUD operations.
- [x] Client list/grid view.
- [x] Client transaction history (Show all invoices for a specific client).

### 📦 Storage/Product Management
- [x] Product CRUD.
- [x] Stock level tracking (Decrease stock when an invoice is finalized).

### 📄 Document Generation
- [ ] **PDF Engine**: Implement `pdf` and `printing` packages.
- [ ] **Invoice Templates**: Design a professional PDF layout.
- [ ] **Preview The File**: Preview the generated invoice pdf before printing it
- [ ] **Sharing**: Add native sharing functionality for PDF files.

### ⚙️ System & Settings
- [x] **Life System Integration**: Ensure compatibility with existing productivity workflow.
- [x] **Theme & Sort**: Persistent sorting preferences and dark/light mode.
- [ ] **Data Export**: CSV/Excel export for accounting.

## 📝 Notes
- Use `ref.invalidate()` to refresh lists after a save.
- Keep business logic in `Notifiers`, keep UI in `Widgets`.
- Ensure all Isar links are `.load()`-ed before display.
