import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;
import javax.swing.border.Border;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

//ToDo: Falsche Eingaben schon in der GUI abfangen
public class FerienwohnungGUI extends JFrame implements ActionListener {
    private Ferienwohnung fw;
    private DefaultListModel<String> searchResult = new DefaultListModel<>();
    private JComboBox<String> countries;
    private JComboBox<String> furnishing;
    private JTextField arrival;
    private JTextField departure;
    private JButton search;
    private JButton book;
    private LogInDialog login;
    private JMenuBar menu;
    private JMenu m;
    private JMenuItem log;

    public FerienwohnungGUI() {
        fw = new Ferienwohnung();
        JPanel mainPanel = new JPanel();
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        this.setTitle("Ferienwohnungen");
        this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                int i = JOptionPane.showConfirmDialog(mainPanel, "Close Application?",
                        "Confirm Dialog", JOptionPane.YES_NO_OPTION);
                if (i == JOptionPane.YES_OPTION) {
                    System.exit(0);
                }
            }
        });
        login = new LogInDialog(this, fw);

        menu = new JMenuBar();
        m = new JMenu("Einloggen");
        menu.add(m);
        log = new JMenuItem("Login");
        log.addActionListener((ActionEvent e) -> {
            login.showDialog();
        });
        m.add(log);
       this.setJMenuBar(menu);


        JPanel suchen = new JPanel();
        Border b = BorderFactory.createTitledBorder("Ferienwohnung Suchen");
        suchen.setBorder(b);
        GridLayout suchenGrid = new GridLayout(3, 2);
        suchen.setLayout(suchenGrid);
        suchenGrid.setHgap(5);

        //Initialize Country Selection
        countries = new JComboBox<>();
        ResultSet rc = fw.getCountries();
        try {
            while (rc.next()) {
                countries.addItem(rc.getString("land_name"));
            }
        } catch (SQLException s) {
            System.out.println("Error while trying to initialize Country Selection");
            fw.actionOnException(s);
        }
        countries.setSelectedIndex(0);
        countries.addActionListener(this);
        suchen.add(countries);

        //Initialize Furnishing Selection
        furnishing = new JComboBox<>();
        furnishing.addItem("");
        ResultSet rf = fw.getFurnishing();
        try {
            while (rf.next()) {
                furnishing.addItem(rf.getString("au_name"));
            }
        } catch (SQLException s) {
            System.out.println("Error while trying to initialize Furnishing Selection");
            fw.actionOnException(s);
        }
        furnishing.setSelectedIndex(0);
        furnishing.addActionListener(this);
        suchen.add(furnishing);

        JLabel anLabel = new JLabel("Ankunftsdatum");
        JLabel abLabel = new JLabel("Abreisedatum");
        String dateFormat = "DD.MM.YYYY";
        arrival = new JTextField(dateFormat, 10);
        departure = new JTextField(dateFormat, 10);

        KeyListener key = new KeyListener() {
            @Override
            public void keyTyped(KeyEvent e) {
                Object source = e.getSource();
                if (source == arrival && arrival.getText().equals(dateFormat)) {
                    arrival.setText("");
                } else if (source == departure && arrival.getText().equals(dateFormat)) {
                    departure.setText("");
                }
            }
            @Override
            public void keyPressed(KeyEvent e) {}

            @Override
            public void keyReleased(KeyEvent e) {}
        };
        arrival.addKeyListener(key);
        departure.addKeyListener(key);

        suchen.add(anLabel);
        suchen.add(abLabel);
        suchen.add(arrival);
        suchen.add(departure);

        JPanel firstPanel =  new JPanel();
        firstPanel.setLayout(new BoxLayout(firstPanel, BoxLayout.X_AXIS));
        search = new JButton("Suchen");
        search.addActionListener((ActionEvent e) ->{
            ResultSet rs = fw.searchFerienwohnung(countries.getSelectedItem().toString(), arrival.getText(),
                    departure.getText(), furnishing.getSelectedItem().toString());
            try {
                while (rs.next()) {
                    rs.getInt("bewertung");
                    //Alternativ: if r.getInt == 0
                    if (rs.wasNull()) {
                        searchResult.addElement(rs.getString("name") + " " + "NB");
                    } else {
                        searchResult.addElement(rs.getString("name") + " " + rs.getInt("bewertung") );
                    }
                }
            } catch (SQLException s) {
                fw.actionOnException(s);
            }
        });
        firstPanel.add(suchen);
        firstPanel.add(search);


        JPanel ausgabe = new JPanel();
        ausgabe.setLayout(new GridLayout());
        JList<String> list = new JList<>(searchResult);
        list.addListSelectionListener(new ListSelectionListener() {
            @Override
            public void valueChanged(ListSelectionEvent e) {

            }
        });
        list.setSelectionMode(DefaultListSelectionModel.SINGLE_SELECTION);
        JScrollPane scrollPane = new JScrollPane(list);
        ausgabe.add(scrollPane);


        JPanel secondPanel = new JPanel();
        firstPanel.setLayout(new BoxLayout(firstPanel, BoxLayout.X_AXIS));
        book = new JButton("Buchen");
        book.addActionListener((ActionEvent e) -> {
            if (login.getMail() == null || login.getPw() == null) {
                JOptionPane.showMessageDialog(secondPanel, "Bitte loggen sie sich zuerst ein");
                return;
            }
            String[] array = list.getSelectedValue().split(" ");
            String fwName = array[0];
            if (fw.bookFerienwohnung(arrival.getText(), departure.getText(), fwName, login.getMail()) == 0) {
                JOptionPane.showMessageDialog(mainPanel, "Buchung fehlgeschlagen");
                System.out.println("Buchung fehlgeschlagen");
            } else {
                JOptionPane.showMessageDialog(mainPanel, "Buchung erfolgreich");
                System.out.println("Buchung erfolgreich");
            }

        });
        secondPanel.add(ausgabe);
        secondPanel.add(book);


        mainPanel.add(firstPanel);
        mainPanel.add(secondPanel);
        setPreferredSize(new Dimension(400, 450));
        pack();
        setContentPane(mainPanel);
        setResizable(false);
        setVisible(true);
    }
    @Override
    public void actionPerformed(ActionEvent e) {

    }

    public static void main(String[] args) {
        new FerienwohnungGUI();
    }


}
