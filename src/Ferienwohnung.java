import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

public class Ferienwohnung {
    private static final String url = "jdbc:oracle:thin:@oracle19c.in.htwg-konstanz.de:1521:ora19c";
    private Connection connect;

    public Ferienwohnung() {
        establishConnection();
    }

    private void establishConnection() {
        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
            connect = DriverManager.getConnection(url, "dbsys42", "dbsys42");
            connect.setAutoCommit(false);

        } catch (SQLException s) {
            actionOnException(s);
        }
    }

    public ResultSet searchFerienwohnung(String land, String anDatum, String abDatum, String ausstattung) {
        PreparedStatement ps;
        ResultSet rs = null;
        String query =
                String.format(
                "SELECT f.fw_name AS name, FLOOR(AVG(b.sterne)) AS bewertung\n" +
                "FROM dbsys26.ferienwohnung f\n" +
                "LEFT JOIN dbsys26.buchung b ON b.fw_name = f.fw_name\n" +
                "LEFT JOIN dbsys26.adresse a ON a.adress_ID = f.adress_ID\n" +
                "LEFT JOIN dbsys26.besitzt be ON be.fw_name = f.fw_name\n" +
                "WHERE a.landname = '%s' \n" +
                "AND f.fw_name NOT IN \n" +
                "(\n" +
                "    SELECT b2.fw_name\n" +
                "    FROM dbsys26.buchung b2\n" +
                "    WHERE '%s' < b2.datum_end AND b2.datum_end < '%s'\n" +
                "    OR '%s' < b2.datum_start  AND b2.datum_start < '%s'\n" +
                "    OR b2.datum_start < '%s' AND b2.datum_end > '%s'\n" +
                "    OR b2.datum_start = '%s' AND b2.datum_end = '%s'" +
                ")\n", land, anDatum, abDatum, anDatum, anDatum, anDatum, abDatum, anDatum, abDatum);
        try {
            String query2;
            if (ausstattung.equals("")) {
                query2 = query +
                        "GROUP BY f.fw_name\n" +
                        "ORDER BY FLOOR(AVG(b.sterne)) DESC NULLS LAST";
            } else {
                query2 = query +
                        "AND be.au_name = '" + ausstattung + "'\n" +
                        "GROUP BY f.fw_name\n" +
                        "ORDER BY FLOOR(AVG(b.sterne)) DESC NULLS LAST ";
            }
            ps = connect.prepareStatement(query2);
            rs = ps.executeQuery();
        } catch (SQLException s) {
            actionOnException(s);
        }
        return rs;
    }

    public ResultSet getCountries() {
        ResultSet rs = null;
        try {
            PreparedStatement ps = connect.prepareStatement("SELECT * FROM dbsys26.land");
            rs = ps.executeQuery();

        } catch (SQLException s) {
            actionOnException(s);
        }
        return rs;
    }

    public ResultSet getFurnishing() {
        ResultSet rs = null;
        try {
            PreparedStatement ps = connect.prepareStatement("SELECT * FROM dbsys26.ausstattung");
            rs = ps.executeQuery();
        } catch (SQLException s) {
            actionOnException(s);
        }
        return rs;
    }

    public int bookFerienwohnung(String startDatum, String endDatum, String fw_name, String mailadr) {
        //INSERT into buchung(buchungsnr, datum_start, datum_end, datum_B, fw_name, mailadr);
        int result = 0;
        try {
            PreparedStatement ps = connect.prepareStatement(
                    "INSERT into dbsys26.buchung(buchungsnr, datum_start, datum_end, datum_B, fw_name, mailadr)" +
                    "VALUES(dbsys26.buchungsnr.NextVal, ?, ?, ?, ?, ?)");
            ps.setString(1, startDatum);
            ps.setString(2, endDatum);
            String pattern = "dd.MM.yyyy";
            String currentDate = new SimpleDateFormat(pattern).format(new Date());
            ps.setString(3, currentDate);
            ps.setString(4, fw_name);
            ps.setString(5, mailadr);

            result = ps.executeUpdate();
            ps.close();
            connect.commit();
        } catch (SQLException s) {
            actionOnException(s);
        }
        return result;
    }

    public boolean confirmLogin(String mail, String pw) {
        Boolean result = false;
        try {
            Statement st = connect.createStatement();
            String query = String.format("SELECT mailadr, passwort FROM dbsys26.kunde k " +
                    "WHERE k.mailadr = '%s' AND k.passwort = '%s'", mail, pw);
            ResultSet rs = st.executeQuery(query);
            if (!rs.next()) {
                return false;
            }
            result = true;
            rs.close();
            /*
            String[] s = new String[2];
            s[0] = rs.getString("mailadr");
            s[1] = rs.getString("passwort");

            if (s[0].equals(mail) && s[1].equals(pw)) {
                result = true;
            }
             */
        } catch (SQLException s) {
            System.out.println("Error while confirming Login");
            actionOnException(s);
        }
        return result;
    }

    protected void actionOnException(SQLException s) {
        System.out.println("SQL Exception occurred while establishing connection to DBSYS: \n");
        System.out.println("SQL State: " + s.getSQLState());
        System.out.println("Message: " + s.getMessage());
        System.out.println("Error Code: " + s.getErrorCode());
        System.out.println();
        System.out.println("Exiting Programm...");
        try {
            connect.rollback();
        } catch (SQLException se) {
            se.printStackTrace();
        }
        System.exit(1);
    }

    public static void main(String[] args) {
        Ferienwohnung fw = new Ferienwohnung();
        Scanner in = new Scanner(System.in);

        System.out.println("Insert Country Name: ");
        String country = in.nextLine();
        System.out.println();

        System.out.println("Insert Arrival Date (Format: DD.MM.YYYY)");
        String arrival = in.nextLine();
        System.out.println();

        System.out.println("Insert Departure Date (Format: DD.MM.YYYY)");
        String departure = in.nextLine();
        System.out.println();

        System.out.println("Optional: Insert preferred Furnishing (Press Enter directly without a Preference)");
        String equip = in.nextLine();
        System.out.println();

        ResultSet r = fw.searchFerienwohnung(country, arrival, departure, equip);
        /*
        if (r.first() == false // r.next()) {
            System.out.println("No Results Found");
            System.exit(0);
        }
         */
        String pattern = "dd.MM.yyyy";
        String dateToString = new SimpleDateFormat(pattern).format(new Date());
        try {
            //r.beforeFirst();
            System.out.println("Ferienwohnung--Bewertung");
            while (r.next()) {
                r.getInt("bewertung");
                //Alternativ: if r.getInt == 0
                if (r.wasNull()) {
                    System.out.println(r.getString("name") + " " + "NB");
                } else {
                    System.out.println(r.getString("name") + " " + r.getInt("bewertung") );
                }
            }
        } catch (SQLException s) {
            fw.actionOnException(s);
        }

        System.out.println("Specify the name of the Apartment you want to book");
        String name = in.nextLine();
        System.out.println();

        System.out.println("Specify your E-Mail");
        String mail = in.nextLine();
        System.out.println();

        int rs = fw.bookFerienwohnung(arrival, departure, name, mail);
        if (rs == 0) {
            System.out.println("Booking failed");
        } else {
            System.out.println("Booking successful");
        }
    }
}
