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

namespace EstadoServidor
{
    public partial class Form1 : Form
    {
        string connectionString = "datasource=127.0.0.1;port=3306;username=estado;password=aoyind!8!3@@;database=aoyind4;";
        string TOTAL_PJ = "select COUNT(*) from pjs";
        string ONLINE = "SELECT COUNT(*) FROM pjs WHERE Logged = 1";
        string NIVEL = "SELECT nombre, elv FROM pjs order by elv desc limit 10";
        string ASESINATOS = "SELECT nombre, CiudMatados + CrimMatados as muertes FROM pjs order by muertes desc limit 10";
        string CANTIDAD_CIUDA = "SELECT COUNT(*) FROM pjs WHERE Rep_Promedio >= 0";
        string CANTIDAD_CRIMI = "SELECT COUNT(*) FROM pjs WHERE Rep_Promedio < 0";
        string FORTALEZAS = "select f.nombre, c.guildname from fortalezas f inner join clanes c";

        Boolean server_online = false;

        Servidor servidor = new Servidor();
        List<Fortaleza> fortalezasLista = new List<Fortaleza>();
        List<Faccion> faccionLista = new List<Faccion>();
        List<Personaje> rankingNivelLista = new List<Personaje>();
        List<Personaje> rankingAsesinatosLista = new List<Personaje>();

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            server_online = true;
            btnServerOnline.Enabled = false;
            btnServerOff.Enabled = true;

            try
            {
                // Cada 5 minutos

                // Me conecto a la base de datos

                // Ejecuto cada consulta y me guardo los datos

                // Me desconecto de la base de datos

                // Actualizo los archivo .txt correspondientes

                // Actualizo el label de ultima actualizacion

                ConectarBD();
            }
            catch(Exception ex)
            {

            }
        }

        private void EjecutarConsulta(string consulta, string tipo)
        {
            try
            {
                MySqlConnection databaseConnection = new MySqlConnection(connectionString);
                MySqlCommand commandDatabase = new MySqlCommand(consulta, databaseConnection);
                commandDatabase.CommandTimeout = 60;
                // Ejecuta la consultas
                // Abre la base de datos
                databaseConnection.Open();
                MySqlDataReader reader = commandDatabase.ExecuteReader();
                if (reader.HasRows)
                {
                    DevolverDato(reader, tipo);
                }

                // Cerrar la conexión
                databaseConnection.Close();
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error al ejecutar la consulta sobre la base de datos, el error es: " + ex.Message);
            }

        }

        private void DevolverDato(MySqlDataReader reader, string tipo)
        {
            if (reader.HasRows)
            {
            if (tipo == "ONLINE")
            {
                while (reader.Read())
                {
                    servidor.cantidad_online = Int32.Parse(reader[0].ToString());
                }
            }
            else if (tipo == "TOTAL")
            {
                while (reader.Read())
                {
                    servidor.cantidad_pj = Int32.Parse(reader[0].ToString());
                }
            }
            else if (tipo == "NIVEL")
            {
                while (reader.Read())
                {
                    Personaje pj = new Personaje();
                    pj.nombre = reader[0].ToString();
                    pj.nivel = Int32.Parse(reader[1].ToString());
                    pj.cantidad_asesinatos = 0;
                    rankingNivelLista.Add(pj);
                }
            }
            else if (tipo == "ASESINATOS")
            {
                while (reader.Read())
                {
                    Personaje pj = new Personaje();
                    pj.nombre = reader[0].ToString();
                    pj.nivel = 0;
                    pj.cantidad_asesinatos = Int32.Parse(reader[1].ToString());
                    rankingAsesinatosLista.Add(pj);
                }
            }
            else if (tipo == "CIUDA")
            {
                while (reader.Read())
                {
                    Faccion faccion = new Faccion();
                    faccion.nombre = "CIUDADANO";
                    faccion.cantidad = Int32.Parse(reader[0].ToString());
                    faccionLista.Add(faccion);
                }
            }
            else if (tipo == "CRIMI")
            {
                while (reader.Read())
                {
                    Faccion faccion = new Faccion();
                    faccion.nombre = "CRIMINAL";
                    faccion.cantidad = Int32.Parse(reader[0].ToString());
                    faccionLista.Add(faccion);
                }
            }
            else if (tipo == "FORTALEZAS")
            {
                while (reader.Read())
                {
                    Fortaleza f = new Fortaleza();
                    f.nombre = reader[0].ToString();
                    f.clan = reader[1].ToString();
                    fortalezasLista.Add(f);
                }
            }


            }

        }

        // cantidad de usuarios online
        // hora del servidor
        private void ActualizarDatoServidor()
        {
            string root = @"C:\\estado";
            // If directory does not exist, don't even try   
            if (Directory.Exists(root))
            {
                string path = @"C:\\estado\\servidor.txt";

                if (File.Exists(path))
                {
                    File.Delete(path);
                }

                //Create the file.  
                using (FileStream fs = File.Create(path))
                {
                    AddText(fs, servidor.estado);
                    AddText(fs, "\r\n" + servidor.cantidad_online.ToString());
                    AddText(fs, "\r\n" + servidor.cantidad_pj.ToString());
                    AddText(fs, "\r\n" + servidor.hora);
                    AddText(fs, "\r\n" + "-*-FIN-*-" + "\r\n");

                    for (int i = 1; i < 120; i++)
                    {
                        AddText(fs, Convert.ToChar(i).ToString());
                    }
                }
            }
        }

        private static void AddText(FileStream fs, string value)
        {
            byte[] info = new UTF8Encoding(true).GetBytes(value);
            fs.Write(info, 0, info.Length);
        }

        // top 10 de ranking por nivel
        private void ActualizarRankingNivel()
        {
            string root = @"C:\\estado";
            // If directory does not exist, don't even try   
            if (Directory.Exists(root))
            {
                string path = @"C:\\estado\\nivel.txt";

                if (File.Exists(path))
                {
                    File.Delete(path);
                }

                if (rankingNivelLista.Count > 0)
                {
                    //Create the file.  
                    using (FileStream fs = File.Create(path))
                    {
                        int nro = 0;
                        foreach (var pj in rankingNivelLista)
                        {
                            if (nro == 0)
                            {
                                AddText(fs, pj.nombre + "," + pj.nivel);
                            }
                            else
                            {
                                AddText(fs, "\r\n" + pj.nombre + "," + pj.nivel);
                            }

                            nro++;
                        }

                        AddText(fs, "\r\n" + "-*-FIN-*-" + "\r\n");

                        for (int i = 1; i < 120; i++)
                        {
                            AddText(fs, Convert.ToChar(i).ToString());
                        }
                    }
                }

            }
        }

        // top 10 de ranking por asesinatos
        private void ActualizarRankingAsesinatos()
        {

            string root = @"C:\\estado";
            // If directory does not exist, don't even try   
            if (Directory.Exists(root))
            {
                string path = @"C:\\estado\\asesinatos.txt";

                if (File.Exists(path))
                {
                    File.Delete(path);
                }

                if (rankingAsesinatosLista.Count > 0)
                {
                    //Create the file.  
                    using (FileStream fs = File.Create(path))
                    {
                        int nro = 0;
                        foreach (var pj in rankingAsesinatosLista)
                        {
                            if (nro == 0)
                            {
                                AddText(fs, pj.nombre + "," + pj.cantidad_asesinatos);
                            }
                            else
                            {
                                AddText(fs, "\r\n" + pj.nombre + "," + pj.cantidad_asesinatos);
                            }

                            nro++;
                        }

                        AddText(fs, "\r\n" + "-*-FIN-*-" + "\r\n");

                        for (int i = 1; i < 120; i++)
                        {
                            AddText(fs, Convert.ToChar(i).ToString());
                        }
                    }
                }
               
            }
        }

        // que clan tiene cada fortaleza
        private void ActualizarFortalezas()
        {

            string root = @"C:\\estado";
            // If directory does not exist, don't even try   
            if (Directory.Exists(root))
            {
                string path = @"C:\\estado\\fortaleza.txt";

                if (File.Exists(path))
                {
                    File.Delete(path);
                }

                if (fortalezasLista.Count > 0)
                {
                    //Create the file.  
                    using (FileStream fs = File.Create(path))
                    {
                        int nro = 0;
                        foreach (var fortaleza in fortalezasLista)
                        {
                            if (nro == 0)
                            {
                                AddText(fs, fortaleza.nombre + "," + fortaleza.clan);
                            }
                            else
                            {
                                AddText(fs, "\r\n" + fortaleza.nombre + "," + fortaleza.clan);
                            }

                            nro++;
                        }

                        AddText(fs, "\r\n" + "-*-FIN-*-" + "\r\n");

                        for (int i = 1; i < 120; i++)
                        {
                            AddText(fs, Convert.ToChar(i).ToString());
                        }
                    }
                }

            }
        }

        // cantidad de pjs creados
        // cantidad de crimis
        // cantidad de ciudas
        private void ActualizarCiudaCrimi() 
        {

            string root = @"C:\\estado";
            // If directory does not exist, don't even try   
            if (Directory.Exists(root))
            {
                string path = @"C:\\estado\\faccion.txt";

                if (File.Exists(path))
                {
                    File.Delete(path);
                }

                int cant_ciuda = 0;
                int cant_crimi = 0;

                foreach(var faccion in faccionLista)
                {
                    if (faccion.nombre == "CIUDADANO")
                    {
                        cant_ciuda = faccion.cantidad;
                    }
                    else if (faccion.nombre == "CRIMINAL")
                    {
                        cant_crimi = faccion.cantidad;
                    }
                }

                //Create the file.  
                using (FileStream fs = File.Create(path))
                {
                    AddText(fs, "CIUDADANOS: " + cant_ciuda);
                    AddText(fs, "\r\n CRIMINALES:" + cant_crimi);
                    AddText(fs, "\r\n TOTAL: "+ servidor.cantidad_pj );
                    AddText(fs, "\r\n" + "-*-FIN-*-" + "\r\n");

                    for (int i = 1; i < 120; i++)
                    {
                        AddText(fs, Convert.ToChar(i).ToString());
                    }
                }
            }
        }

        private void ConectarBD()
        {
            try {
                if (server_online == true)
                {
                    servidor.cantidad_online = 0;
                    servidor.cantidad_pj = 0;
                    fortalezasLista.Clear();
                    faccionLista.Clear();
                    rankingNivelLista.Clear();
                    rankingAsesinatosLista.Clear();
                    servidor.estado = "ONLINE";
                    lblEstado.Text = "ONLINE";
                    lblEstado.ForeColor = Color.DarkGreen;
                    // Ejecuta la consultas
                    EjecutarConsulta(TOTAL_PJ, "TOTAL");
                    EjecutarConsulta(ONLINE, "ONLINE");
                    EjecutarConsulta(NIVEL, "NIVEL");
                    EjecutarConsulta(ASESINATOS, "ASESINATOS");
                    EjecutarConsulta(CANTIDAD_CIUDA, "CIUDA");
                    EjecutarConsulta(CANTIDAD_CRIMI, "CRIMI");
                    EjecutarConsulta(FORTALEZAS, "FORTALEZAS");

                    string date = DateTime.UtcNow.ToString("dd-MM-yyyy HH:mm:ss");
                    lblUltimaActualizacion.Text = date;
                    servidor.hora = date;

                    ActualizarDatoServidor();
                    ActualizarCiudaCrimi();
                    ActualizarRankingAsesinatos();
                    ActualizarRankingNivel();
                }
                else
                {
                    lblEstado.Text = "OFFLINE";
                    lblEstado.ForeColor = Color.DarkRed;
                }
               
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error al ejecutar la consulta sobre la base de datos, el error es: " + ex.Message);
            }
        }

        private void btnServerOnline_Click(object sender, EventArgs e)
        {
            server_online = true;
            lblEstado.Text = "ONLINE";
            lblEstado.ForeColor = Color.DarkGreen;
            btnServerOnline.Enabled = false;
            btnServerOff.Enabled = true;
        }

        private void btnServerOff_Click(object sender, EventArgs e)
        {
            server_online = false;
            lblEstado.Text = "OFFLINE";
            lblEstado.ForeColor = Color.DarkRed;
            btnServerOnline.Enabled = true;
            btnServerOff.Enabled = false;
        }
    }
}
