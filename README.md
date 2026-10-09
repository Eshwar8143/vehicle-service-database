# Vehicle Service Database 

Hey! This is a relational database management system I built using MySQL to handle the day-to-day operations of a vehicle service center. 

## What's this project about?
Managing a service center manually is messy. This database keeps everything organized in one place—tracking customers, their vehicles (bikes, cars, trucks), mechanic assignments, inventory spare parts, supplier orders, and final billing.

## Database Structure 
The database is built with **11 normalized tables** linked together with proper primary and foreign keys (including cascading deletes so things clean up properly if a customer is removed):

- **Core Setup:** `customer`, `vehicle`, `mechanic`, `service`, `spare_part`, `supplier`
- **Operations & Money:** `job_card`, `job_services`, `service_part`, `purchase`, `bill`

## Cool Features Built-In
- **Data Safety (Constraints):** Added `CHECK` constraints so the system won't accept weird things like negative prices, negative stock, or invalid work statuses.
- **Clean Mappings:** Mechanics are correctly matched to their respective vehicle specializations (no truck mechanics fixing bikes!), and pending jobs leave delivery dates blank until they're actually finished.
- **Accurate Billing:** Bills are properly tallied up by combining the service charges and parts used.

## How to Run It
1. Clone the repo:
   ```bash
   git clone https://github.com/Eshwar8143/vehicle-service-database.git
   ```
2. Open up your MySQL Workbench or terminal.
3. Run the `vehicle_service.sql` file to spin up the database and sample data!
