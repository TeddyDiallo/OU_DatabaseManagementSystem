import java.io.FileReader;
import java.sql.*;
import java.util.Scanner;
import java.io.*;
import java.sql.*;
import java.util.Scanner;
public class JobShopAccounting {

    public static void main(String[] args) {
        // JDBC connection setup
        String url = "jdbc:sqlserver://dial0007.database.windows.net:1433;database=cs-dsa-4513-sql-db;user=dial0007@dial0007;password=Candidatkey99;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30";
        String user = "dial0007";
        String password = "Candidatkey99";

        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            Scanner scanner = new Scanner(System.in);

            while (true) {
                // Display menu options
                System.out.println("Options:");
                System.out.println("1. Enter a new customer");
                System.out.println("2. Enter a new department");
                System.out.println("3. Enter a new process-id and its department together with its type and information relevant to the type");
                System.out.println("4. Enter a new assembly with its customer-name, assembly-details, assembly-id, and date-ordered and associate it with one or more processes");
                System.out.println("5. Create a new account and associate it with the process, assembly, or department to which it is applicable");
                System.out.println("6. Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced");
                System.out.println("7. At the completion of a job, enter the date it completed and the information relevant to the type of job");
                System.out.println("8. Enter a transaction-no and its sup-cost and update all the costs (details) of the affected accounts by adding sup-cost to their current values of details");
                System.out.println("9. Retrieve the total cost incurred on an assembly-id");
                System.out.println("10. Retrieve the total labor time within a department for jobs completed in the department during a given date");
                System.out.println("11. Retrieve the processes through which a given assembly-id has passed so far (in date-commenced order) and the department responsible for each process");
                System.out.println("12. Retrieve the customers (in name order) whose category is in a given range");
                System.out.println("13. Delete all cut-jobs whose job-no is in a given range");
                System.out.println("14. Change the color of a given paint job");
                System.out.println("15. Import option: enter new customers from a data file");
                System.out.println("16. Export option: output customers in a data file");
                System.out.println("17. Exit the program");
                System.out.println("Enter your choice (1-17): ");
                int choice = scanner.nextInt();

                switch (choice) {
                    case 1:
                        executeQueryForOption1(connection, scanner);
                        break;
                    case 2:
                        executeQueryForOption2(connection, scanner);
                        break;
                    case 3:
                        executeQueryForOption3(connection, scanner);
                        break;
                    case 17:
                        // Option 4: Quit
                        System.out.println("Exiting the program.");
                        System.exit(0);
                        break;
                    case 4:
                        executeQueryForOption4(connection, scanner);
                        break;
                    case 5:
                        executeQueryForOption5(connection, scanner);
                        break;
                    case 6:
                        executeQueryForOption6(connection, scanner);
                        break;
                    case 7:
                        // Execute the query for option 7
                        executeQueryForOption7(connection, scanner);
                        break;
                    case 8:
                        // Execute the query for option 8
                        executeQueryForOption8(connection, scanner);
                        break;
                    case 9:
                        // Execute the query for option 9
                        executeQueryForOption9(connection, scanner);
                        break;
                    case 10:
                        // Execute the query for option 10
                        executeQueryForOption10(connection, scanner);
                        break;
                    case 11:
                        // Execute the query for option 11
                        executeQueryForOption11(connection, scanner);
                        break;
                    case 12:
                        // Execute the query for option 12
                        executeQueryForOption12(connection, scanner);
                        break;
                    case 13:
                        // Execute the query for option 13
                        executeQueryForOption13(connection, scanner);
                        break;
                    case 14:
                        // Execute the query for option 14
                        executeQueryForOption14(connection, scanner);
                        break; 
                    case 15:
                        // Execute the query for option 15
                        executeQueryForOption15(connection, scanner);
                        break; 
                    case 16:
                        // Execute the query for option 16
                        executeQueryForOption16(connection, scanner);
                        break; 
                    default:
                        System.out.println("Invalid choice. Please enter a number between 1 and 17.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Define methods to execute the 17 queries (replace with your actual SQL queries)
    
    //Input taking for query 1
    private static void executeQueryForOption1(Connection connection, Scanner scanner) throws SQLException {
    	// Get user input for customer details
        System.out.println("Enter Customer Name:");
        String name = scanner.next();
        
        System.out.println("Enter Customer Address:");
        String address = scanner.next();

        System.out.println("Enter Customer Category:");
        int category = scanner.nextInt();
        
     // Call the stored procedure to insert the new customer
        insertCustomer(connection, name, address, category); //Put user input in table
        
        System.out.println("New customer inserted successfully!");
    }
    //Connection to the DBMS for query 1 
    public static void insertCustomer(Connection connection, String nameCustomer, String addressCustomer, int category) throws SQLException {
        String sql = "{call insertCustomer(?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setString(1, nameCustomer);
            statement.setString(2, addressCustomer);
            statement.setInt(3, category);
            statement.execute();
        }
    }
    
    private static void executeQueryForOption2(Connection connection, Scanner scanner) throws SQLException {
    	// Get user input for department details
        System.out.println("Enter Department Number:");
        int deptNo = scanner.nextInt();

        System.out.println("Enter Department Data:");
        String deptData = scanner.next();
        
     // Call the stored procedure to insert the new department
        insertDepartment(connection, deptNo, deptData); //Put user input in table

        System.out.println("New department inserted successfully!");
    }
    
    public static void insertDepartment(Connection connection, int deptNo, String deptData) throws SQLException {
        String sql = "{call insertDepartment(?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, deptNo);
            statement.setString(2, deptData);
            statement.execute();
        }
    }
    
    private static void executeQueryForOption3(Connection connection, Scanner scanner) throws SQLException {
        // Get user input for process details
        System.out.println("Enter Process ID:");
        int processId = scanner.nextInt();

        System.out.println("Enter Department Number:");
        int deptNo = scanner.nextInt();

        System.out.println("Enter Process Data:");
        String processData = scanner.next();

        System.out.println("Select your process type: "
                + "1 = Fit process "
                + "2 = Paint process "
                + "3 = Cut process");
        int processType = scanner.nextInt();

        if (processType == 1) {
            System.out.println("Enter Fit Type:");
            String fitType = scanner.next();

            insertFitProcess(connection, processId, deptNo, processData, fitType);

            System.out.println("New fit type process inserted successfully!");
        } else if (processType == 2) {
            System.out.println("Enter Paint type:");
            String paintType = scanner.next();

            System.out.println("Enter painting method:");
            String paintMethod = scanner.next();

            insertPaintProcess(connection, processId, deptNo, processData, paintType, paintMethod);

            System.out.println("New paint type process inserted successfully!");
        } else if (processType == 3) {
            System.out.println("Enter cutting type:");
            String cutType = scanner.next();

            System.out.println("Enter machine type:");
            String machineType = scanner.next();

            insertCutProcess(connection, processId, deptNo, processData, cutType, machineType);

            System.out.println("New cut type process inserted successfully!");
        } else {
            System.out.println("Invalid process type");
        }
    }

    public static void insertFitProcess(Connection connection, int processId, int deptNo, String processData, String fitType) throws SQLException {
        String sql = "{call insertFitProcess(?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, processId);
            statement.setInt(2, deptNo);
            statement.setString(3, processData);
            statement.setString(4, fitType);
            statement.execute();
        }
    }

    public static void insertPaintProcess(Connection connection, int processId, int deptNo, String processData, String paintType, String paintMethod) throws SQLException {
        String sql = "{call insertPaintProcess(?, ?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, processId);
            statement.setInt(3, deptNo);
            statement.setString(2, processData);
            statement.setString(4, paintType);
            statement.setString(5, paintMethod);
            statement.execute();
        }
    }

    public static void insertCutProcess(Connection connection, int processId, int deptNo, String processData, String cutType, String machineType) throws SQLException {
        String sql = "{call insertCutProcess(?, ?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, processId);
            statement.setInt(3, deptNo);
            statement.setString(2, processData);
            statement.setString(4, cutType);
            statement.setString(5, machineType);
            statement.execute();
        }
    }
    
    private static void executeQueryForOption4(Connection connection, Scanner scanner) throws SQLException {
    	// Get user input for assembly details
        System.out.println("Enter Assembly ID:");
        int assemblyId = scanner.nextInt();

        System.out.println("Enter Date Ordered:");
        String dateOrdered = scanner.next();

        System.out.println("Enter Assembly Details:");
        String assemblyDetails = scanner.next();

        System.out.println("Enter Customer Name:");
        String customerName = scanner.next();
        
        System.out.println("Enter the processes associated with the "
        		+ "assembly and separate them with a comma if there are several.");
        String processIds = scanner.next();
        
     // Call the stored procedure to insert the new performer (Option 1)
        insertAssembly(connection, assemblyId, dateOrdered, assemblyDetails, customerName, processIds); //Put user input in table

        System.out.println("New assembly inserted successfully!");
    }
    
    public static void insertAssembly(Connection connection, int assemblyId, String dateOrdered, String assemblyDetails, String customerName, String processIds) throws SQLException {
        String sql = "{call InsertAssembly(?, ?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, assemblyId);
            statement.setString(2, dateOrdered);
            statement.setString(3, assemblyDetails);
            statement.setString(4, customerName);
            statement.setString(5, processIds);
            statement.execute();
        }
    }
    
    private static void executeQueryForOption5(Connection connection, Scanner scanner) throws SQLException {
    	// Get user input for account assembly details
        System.out.println("Enter Account Number:");
        int accountNo = scanner.nextInt();

        System.out.println("Enter Creation Date:");
        String creationDate = scanner.next();

        System.out.println("Select your account type: "
        		+ " 1 = Assembly account"
        		+ " 2 = Department account"
        		+ " 3 = Process account");
        int accountType = scanner.nextInt();
        
        if (accountType == 1) {
            System.out.println("Enter assembly account details:");
            int details1 = scanner.nextInt();
            System.out.println("Enter the associated assemly id: ");
            int assemblyId = scanner.nextInt();
            createAssemblyAccount(connection, accountNo, creationDate, details1, assemblyId); //Put user input in table
            System.out.println("New assembly account inserted successfully!");
        }
        
        else if (accountType == 2) {
            System.out.println("Enter department account details:");
            int details2 = scanner.nextInt();
            System.out.println("Enter the associated department number: ");
            int deptNo = scanner.nextInt();
            createDepartmentAccount(connection, accountNo, creationDate, details2, deptNo); //Put user input in table
            System.out.println("New department account inserted successfully!");
        }
        else if (accountType == 3) {
            System.out.println("Enter process account details:");
            int details3 = scanner.nextInt();
            System.out.println("Enter the associated process id: ");
            int processId = scanner.nextInt();
            createProcessAccount(connection, accountNo, creationDate, details3, processId); //Put user input in table
            System.out.println("New process account inserted successfully!");
        }
        
    }
    
    public static void createAssemblyAccount(Connection connection, int accountNo, String creationDate, int details1, int assemblyId) throws SQLException {
        String sql = "{call createAssemblyAccount(?, ?, ?, ?)}";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountNo);
            statement.setString(2, creationDate);
            statement.setInt(3, details1);
            statement.setInt(4, assemblyId);
            statement.executeUpdate();
        }
    }
    
    public static void createDepartmentAccount(Connection connection, int accountNo, String creationDate, int details2, int deptNo) throws SQLException {
        String sql = "{call createDepartmentAccount(?, ?, ?, ?)}";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountNo);
            statement.setString(2, creationDate);
            statement.setInt(3, details2);
            statement.setInt(4, deptNo);
            statement.executeUpdate();
        }
    }
    
    public static void createProcessAccount(Connection connection, int accountNo, String creationDate, int details3, int processId) throws SQLException {
        String sql = "{call createProcessAccount(?, ?, ?, ?)}";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountNo);
            statement.setString(2, creationDate);
            statement.setInt(3, details3);
            statement.setInt(4, processId);
            statement.executeUpdate();
        }
    }
    
    private static void executeQueryForOption6(Connection connection, Scanner scanner) throws SQLException {
        // Get user input for job details
        System.out.println("Enter Job Number:");
        int jobNo = scanner.nextInt();

        System.out.println("Enter Assembly ID:");
        int assemblyId = scanner.nextInt();

        System.out.println("Enter Process ID:");
        int processId = scanner.nextInt();

        System.out.println("Enter date the job commenced (YYYY-MM-DD):");
        String dateStart = scanner.next();
        
        System.out.println("Enter the job type (1 = Job Fit, 2 = Job Paint, 3 = Job Cut)");
        int jobType = scanner.nextInt();

        switch (jobType) {
            case 1:
                insertJobFit(connection, jobNo, assemblyId, processId, dateStart);
                System.out.println("New FIT job inserted successfully!");
                break;
            case 2:
                insertJobPaint(connection, jobNo, assemblyId, processId, dateStart);
                System.out.println("New PAINT job inserted successfully!");
                break;
            case 3:
                insertJobCut(connection, jobNo, assemblyId, processId, dateStart);
                System.out.println("New CUT job inserted successfully!");
                break;
            default:
                System.out.println("Invalid job type");
        }
    }

    public static void insertJobFit(Connection connection, int jobNo, int assemblyId, int processId, String dateStart) throws SQLException {
        String sql = "{call insertJobFit(?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, jobNo);
            statement.setInt(2, assemblyId);
            statement.setInt(3, processId);
            statement.setString(4, dateStart);
            statement.execute();
        }
    }

    public static void insertJobPaint(Connection connection, int jobNo, int assemblyId, int processId, String dateStart) throws SQLException {
        String sql = "{call insertJobPaint(?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, jobNo);
            statement.setInt(2, assemblyId);
            statement.setInt(3, processId);
            statement.setString(4, dateStart);
            statement.execute();
        }
    }

    public static void insertJobCut(Connection connection, int jobNo, int assemblyId, int processId, String dateStart) throws SQLException {
        String sql = "{call insertJobCut(?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, jobNo);
            statement.setInt(2, assemblyId);
            statement.setInt(3, processId);
            statement.setString(4, dateStart);
            statement.execute();
        }
    }
    
    
    private static void executeQueryForOption7(Connection connection, Scanner scanner) throws SQLException {
        // Get user input for job details
        System.out.println("Enter the job type you want to update (1 = Job Fit, 2 = Job Paint, 3 = Job Cut)");
        int jobType = scanner.nextInt();

        switch (jobType) {
            case 1:
            	System.out.println("Enter Fit Job Number:");
                int fitJobNo = scanner.nextInt();

                System.out.println("Enter Completion Date (YYYY-MM-DD):");
                String completionDateFit = scanner.next();

                System.out.println("Enter Labor Time for Fit Job:");
                double laborTimeFit = scanner.nextDouble();

                // Call the stored procedure
                completeFitJob(connection, fitJobNo, completionDateFit, laborTimeFit);

                System.out.println("Fit Job completed successfully!");
                break;
            
            case 2:
            	System.out.println("Enter Paint Job Number:");
                int paintJobNo = scanner.nextInt();

                System.out.println("Enter Completion Date (YYYY-MM-DD):");
                String completionDatePaint = scanner.next();

                System.out.println("Enter Paint Color:");
                String color = scanner.next();

                System.out.println("Enter Paint Volume:");
                int volume = scanner.nextInt();

                System.out.println("Enter Labor Time for Paint Job:");
                double laborTimePaint = scanner.nextDouble();

                // Call the stored procedure
                completePaintJob(connection, paintJobNo, completionDatePaint, color, volume, laborTimePaint);

                System.out.println("Paint Job completed successfully!");
                break;
            case 3:
            	System.out.println("Enter Cut Job Number:");
                int cutJobNo = scanner.nextInt();

                System.out.println("Enter Completion Date (YYYY-MM-DD):");
                String completionDateCut = scanner.next();

                System.out.println("Enter Machine Type Used for Cut Job:");
                String machineType = scanner.next();

                System.out.println("Enter Time Machine Used for Cut Job:");
                double timeMachineUsed = scanner.nextDouble();

                System.out.println("Enter Material Used for Cut Job:");
                String materialUsed = scanner.next();

                System.out.println("Enter Labor Time for Cut Job:");
                double laborTimeCut = scanner.nextDouble();

                // Call the stored procedure
                completeCutJob(connection, cutJobNo, completionDateCut, machineType, timeMachineUsed, materialUsed, laborTimeCut);

                System.out.println("Cut Job completed successfully!");
                System.out.println("New CUT job inserted successfully!");
                break;
            default:
                System.out.println("Invalid job type");
        }
    }
    private static void completeFitJob(Connection connection, int jobNo, String dateEnd, double laborTime) throws SQLException {
        String sql = "{call completeFitJob(?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, jobNo);
            statement.setString(2, dateEnd);
            statement.setDouble(3, laborTime);
            statement.execute();
        }
    }
    private static void completePaintJob(Connection connection, int jobNo, String dateEnd, String color, int volume, double laborTime) throws SQLException {
        String sql = "{call completePaintJob(?, ?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, jobNo);
            statement.setString(2, dateEnd);
            statement.setString(3, color);
            statement.setInt(4, volume);
            statement.setDouble(5, laborTime);
            statement.execute();
        }
    }

    private static void completeCutJob(Connection connection, int jobNo, String dateEnd, String machineType, double timeMachineUsed, String materialUsed, double laborTime) throws SQLException {
        String sql = "{call completeCutJob(?, ?, ?, ?, ?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, jobNo);
            statement.setString(2, dateEnd);
            statement.setString(3, machineType);
            statement.setDouble(4, timeMachineUsed);
            statement.setString(5, materialUsed);
            statement.setDouble(6, laborTime);
            statement.execute();
        }
    }
    
    private static void executeQueryForOption8(Connection connection, Scanner scanner) throws SQLException {
    // Prompt the user to enter input for the stored procedure
    System.out.println("Enter Transaction Number:");
    int transactionNo = scanner.nextInt();

    System.out.println("Enter Supplier Cost:");
    double supCost = scanner.nextDouble();

    System.out.println("Enter Assembly Account Number (or enter 0 if not applicable):");
    int assemblyAccountNo = scanner.nextInt();

    System.out.println("Enter Process Account Number (or enter 0 if not applicable):");
    int processAccountNo = scanner.nextInt();

    System.out.println("Enter Department Account Number (or enter 0 if not applicable):");
    int deptAccountNo = scanner.nextInt();

    // Call the stored procedure
    executeEnterTransactionAndUpdateAccounts(connection, transactionNo, supCost, assemblyAccountNo, processAccountNo, deptAccountNo);

    System.out.println("Transaction successfully entered and accounts updated!");
} 


    private static void executeEnterTransactionAndUpdateAccounts(Connection connection, int transactionNo, double supCost, int assemblyAccountNo, int processAccountNo, int deptAccountNo) throws SQLException {
        String sql = "{call enterTransactionAndUpdateAccounts(?, ?, ?, ?, ?)}";

        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, transactionNo);
            statement.setDouble(2, supCost);

            if (assemblyAccountNo == 0) {
                statement.setNull(3, java.sql.Types.INTEGER);
            } else {
                statement.setInt(3, assemblyAccountNo);
            }

            if (processAccountNo == 0) {
                statement.setNull(4, java.sql.Types.INTEGER);
            } else {
                statement.setInt(4, processAccountNo);
            }

            if (deptAccountNo == 0) {
                statement.setNull(5, java.sql.Types.INTEGER);
            } else {
                statement.setInt(5, deptAccountNo);
            }

            statement.execute();
        }
    }
    
    private static void executeQueryForOption9(Connection connection, Scanner scanner) throws SQLException {
        // Get user input for assembly ID
        System.out.println("Enter Assembly ID:");
        int assemblyId = scanner.nextInt();

        // Call the stored procedure
        double totalCost = executeCalculateTotalCostForAssembly(connection, assemblyId);

        // Display the result
        System.out.println("Total Cost for Assembly ID " + assemblyId + ": " + totalCost);
    }

    private static double executeCalculateTotalCostForAssembly(Connection connection, int assemblyId) throws SQLException {
        String sql = "{call calculateTotalCostForAssembly(?)}";

        try (CallableStatement statement = connection.prepareCall(sql)) {
            // Set the input parameter
            statement.setInt(1, assemblyId);

            // Execute the stored procedure
            statement.execute();

            // Retrieve the total cost
            double totalCost;
            try (ResultSet rs = statement.getResultSet()) {
                if (rs.next()) {
                    totalCost = rs.getDouble(1); // Assuming the total cost is the first column
                } else {
                    totalCost = 0; // Handle the case where no value is returned
                }
            }

            return totalCost;
        }
    }
    
    private static void executeQueryForOption10(Connection connection, Scanner scanner) throws SQLException {
        // Get user input for department number and date
        System.out.println("Enter Department Number:");
        int deptNo = scanner.nextInt(); // Read department number
        scanner.nextLine(); // Consume the newline left-over

        System.out.println("Enter the date (YYYY-MM-DD):");
        String givenDate = scanner.nextLine(); // Read the given date

        // Call the stored procedure
        int totalLaborTime = executeTotalLaborTimeInDepartment(connection, deptNo, givenDate);

        // Display the result
        System.out.println("Total Labor Time for Department " + deptNo + " on " + givenDate + ": " + totalLaborTime);
    }

    private static int executeTotalLaborTimeInDepartment(Connection connection, int deptNo, String givenDate) throws SQLException {
        String sql = "{call TotalLaborTimeInDepartment_WithIndex(?, ?, ?)}";

        try (CallableStatement statement = connection.prepareCall(sql)) {
            // Set the input parameters
            statement.setInt(1, deptNo);
            statement.setString(2, givenDate);

            // Register the output parameter
            statement.registerOutParameter(3, Types.INTEGER);

            // Execute the stored procedure
            statement.execute();

            // Retrieve the total labor time from the output parameter
            int totalLaborTime = statement.getInt(3);

            return totalLaborTime;
        }
    }
    private static void executeQueryForOption13(Connection connection, Scanner scanner) throws SQLException {
        System.out.println("Enter the start job number:");
        int startJobNo = scanner.nextInt(); // Read start job number
        System.out.println("Enter the end job number:");
        int endJobNo = scanner.nextInt(); // Read end job number

        deleteCutJobsInRange(connection, startJobNo, endJobNo);

        System.out.println("Cut jobs in range " + startJobNo + " to " + endJobNo + " have been deleted.");
    }

    private static void deleteCutJobsInRange(Connection connection, int startJobNo, int endJobNo) throws SQLException {
        String sql = "{call deleteCutJobsInRange(?, ?)}";

        try (CallableStatement statement = connection.prepareCall(sql)) {
            // Set the input parameters
            statement.setInt(1, startJobNo);
            statement.setInt(2, endJobNo);

            // Execute the stored procedure
            statement.execute();
        }
    }

    private static void executeQueryForOption14(Connection connection, Scanner scanner) throws SQLException {
        System.out.println("Enter the job number for the paint job:");
        int jobNo = scanner.nextInt(); // Read job number
        scanner.nextLine(); // Consume the newline left-over
        
        System.out.println("Enter the new color for the paint job:");
        String newColor = scanner.nextLine(); // Read the new color

        updatePaintJobColor(connection, jobNo, newColor);

        System.out.println("The color of paint job " + jobNo + " has been changed to " + newColor + ".");
    }

    private static void updatePaintJobColor(Connection connection, int jobNo, String newColor) throws SQLException {
        String sql = "{call updatePaintJobColor(?, ?)}";

        try (CallableStatement statement = connection.prepareCall(sql)) {
            // Set the input parameters
            statement.setInt(1, jobNo);
            statement.setString(2, newColor);

            // Execute the stored procedure
            statement.execute();
        }
    }
    
    
    private static void executeQueryForOption11(Connection connection, Scanner scanner) throws SQLException {
        System.out.println("Enter the assembly ID:");
        int assemblyId = scanner.nextInt(); // Read assembly ID

        retrieveProcessesForAssembly(connection, assemblyId);
    }

    private static void retrieveProcessesForAssembly(Connection connection, int givenAssemblyId) throws SQLException {
        String sql = "{call ProcessesForAssembly_WithIndex(?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, givenAssemblyId);

            boolean hasResults = statement.execute();

            if (hasResults) {
                try (ResultSet rs = statement.getResultSet()) {
                    while (rs.next()) {
                        int assemblyId = rs.getInt("assembly_id");
                        int processId = rs.getInt("process_id");
                        String processData = rs.getString("process_data");
                        int deptNo = rs.getInt("dept_no");
                        String departmentResponsible = rs.getString("department_responsible");

                        System.out.println("Assembly ID: " + assemblyId + ", Process ID: " + processId + 
                                           ", Process Data: " + processData + ", Department Number: " + deptNo + 
                                           ", Department Responsible: " + departmentResponsible);
                    }
                }
            } else {
                System.out.println("No processes found for assembly ID " + givenAssemblyId);
            }
        }
    }
    
    private static void executeQueryForOption12(Connection connection, Scanner scanner) throws SQLException {
        System.out.println("Enter the start category range:");
        int startCategory = scanner.nextInt(); // Read start category
        System.out.println("Enter the end category range:");
        int endCategory = scanner.nextInt(); // Read end category

        retrieveCustomerByRange(connection, startCategory, endCategory);
    }

    private static void retrieveCustomerByRange(Connection connection, int categoryStart, int categoryEnd) throws SQLException {
        String sql = "{call retrieveCustomerByRange(?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setInt(1, categoryStart);
            statement.setInt(2, categoryEnd);

            boolean hasResults = statement.execute();

            if (hasResults) {
                try (ResultSet rs = statement.getResultSet()) {
                    while (rs.next()) {
                        String nameCustomer = rs.getString("name_customer");
                        String addressCustomer = rs.getString("address_customer");
                        int category = rs.getInt("category");

                        System.out.println("Customer Name: " + nameCustomer + ", Address: " + addressCustomer + 
                                           ", Category: " + category);
                    }
                }
            } else {
                System.out.println("No customers found in the given category range " + categoryStart + " to " + categoryEnd);
            }
        }
    }
    
    private static void executeQueryForOption15(Connection connection, Scanner scanner) {
        System.out.println("Enter the input file name:");
        String fileName = scanner.next(); // Read the file name

        try {
            // Open the file
            try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    // Assuming the file has comma-separated values (CSV) like name,address,category
                    String[] customerData = line.split(",");
                    if (customerData.length == 3) {
                        insertExportedCustomer(connection, customerData[0], customerData[1], Integer.parseInt(customerData[2]));
                    }
                }
            }
            System.out.println("All customers from the file have been inserted.");
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + fileName);
        } catch (IOException e) {
            System.out.println("An error occurred while reading the file.");
        } catch (SQLException e) {
            System.out.println("An error occurred while inserting the customer data into the database.");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            System.out.println("Category must be an integer.");
        }
    }
    
    private static void insertExportedCustomer(Connection connection, String name, String address, int category) throws SQLException {
        String sql = "{call insertCustomer(?, ?, ?)}";

        try (CallableStatement statement = connection.prepareCall(sql)) {
            statement.setString(1, name.trim());
            statement.setString(2, address.trim());
            statement.setInt(3, category); // No need to convert to integer as it is already an integer

            statement.executeUpdate();
        }
    }
    
    private static void executeQueryForOption16(Connection connection, Scanner scanner) throws SQLException {
        System.out.println("Enter the start category range:");
        int startCategory = scanner.nextInt(); // Read start category
        System.out.println("Enter the end category range:");
        int endCategory = scanner.nextInt(); // Read end category
        scanner.nextLine(); // Consume the newline left-over

        System.out.println("Enter the output file name:");
        String outputFileName = scanner.nextLine(); // Read the output file name

        exportCustomersToDataFileUsingStoredProc(connection, startCategory, endCategory, outputFileName);
    }

    private static void exportCustomersToDataFileUsingStoredProc(Connection connection, int startCategory, int endCategory, String outputFileName) throws SQLException {
        String sql = "{call retrieveCustomerByRange(?, ?)}";
        try (CallableStatement statement = connection.prepareCall(sql);
             BufferedWriter writer = new BufferedWriter(new FileWriter(outputFileName))) {

            statement.setInt(1, startCategory);
            statement.setInt(2, endCategory);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                String nameCustomer = rs.getString("name_customer");
                String addressCustomer = rs.getString("address_customer");
                int category = rs.getInt("category");
                String customerRecord = nameCustomer + "," + addressCustomer + "," + category;

                writer.write(customerRecord);
                writer.newLine(); // To move to the next line for the next record
            }

            System.out.println("Customer data has been written to " + outputFileName);
        } catch (IOException e) {
            System.out.println("An error occurred while writing to the file: " + e.getMessage());
        }
    }




}
    

