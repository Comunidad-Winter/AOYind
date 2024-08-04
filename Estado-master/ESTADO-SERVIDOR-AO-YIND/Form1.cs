using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data.MySqlClient;
using System.IO;

namespace ESTADO_SERVIDOR_AO_YIND
{
    public partial class Form1 : Form
    {
        string connectionString = "datasource=127.0.0.1;port=3306;username=root;password=;database=test;";
        string TOTAL_PJ = "select COUNT(*) from pjs";
        string ONLINE = "SELECT * FROM pjs WHERE Logged = 1";
        string NIVEL = "SELECT nombre, elv FROM pjs order by elv desc limit 10";
        string ASESINATOS = "SELECT nombre, CiudMatados + CrimMatados as muertes FROM pjs order by muertes desc limit 10";
        string PERSONAJES_CIUDA_CRIMI = "SELECT nombre, Rep_Promedio FROM pjs order by Rep_Promedio desc";
        string FORTALEZAS = "select f.nombre, c.guildname from fortalezas f inner join clanes c";

        public Form1()
        {
            InitializeComponent();
        }

        private void btnActualizar_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void ConectarBD()
        {
            try
            {
                MySqlConnection conexion = new MySqlConnection(connectionString);
                conexion.Open();

            }
            catch (Exception ex)
            {

            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string root = @"C:\\aoyind-estado";
            string archivo = "database.txt";
            // If directory does not exist, don't even try   
            if (Directory.Exists(root))
            {
                if (File.Exists(root + "\\" + archivo))
                { // Create a file to write to   
                    
                }
                else
                {
                    MessageBox.Show("Crear el archivo database.txt, dentro de la carpeta aoyind-estado en el directorio C.");
                }
            }
            else
            {
                MessageBox.Show("Dentro del directorio C, crear una carpeta con nombre: aoyind-estado");
            }
            
        }
    }
}
