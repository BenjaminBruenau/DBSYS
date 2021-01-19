import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class LogInDialog extends JDialog implements ActionListener {
    private final JTextField mailadress;
    private final JTextField password;
    private final JButton login;
    private String mail;
    private String pw;

    public LogInDialog(JFrame f, Ferienwohnung fw) {
        super(f, "Einloggen mit Kundenkonto", true);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        mailadress = new JTextField(10);
        password = new JTextField(10);

        login = new JButton("Einloggen");
        login.addActionListener((ActionEvent e) -> {
            this.mail = mailadress.getText();
            this.pw = password.getText();
            if (!fw.confirmLogin(getMail(), getPw())) {
                JOptionPane.showMessageDialog(login, "Ungültige Mailadresse oder Passwort");
                return;
            }
            setVisible(false);
        });

        JButton cancel = new JButton("Abbrechen");
        cancel.addActionListener((ActionEvent e) -> setVisible(false));

        JPanel panel = new JPanel(new GridLayout(0, 2, 5, 5));
        panel.add(new JLabel("E-Mail", JLabel.RIGHT));
        panel.add(mailadress);
        panel.add(new JLabel("Passwort", JLabel.RIGHT));
        panel.add(password);
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        this.add(panel, BorderLayout.CENTER);

        JPanel panel2 = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        panel2.add(cancel);
        panel2.add(login);
        this.add(panel2, BorderLayout.SOUTH);
        pack();
    }

    public void showDialog() {
        mailadress.setText("");
        password.setText("");
        this.mail = "";
        this.pw = "";
        setVisible(true);
    }
    public String getMail() {
        return this.mail;
    }

    public String getPw() {
        return this.pw;
    }
    @Override
    public void actionPerformed(ActionEvent e) {}
}
