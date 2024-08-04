using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Net;

namespace Instalador_AO_YIND
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            txtCarpeta.Enabled = false;
        }

        private void btnSeleccionarCarpeta_Click(object sender, EventArgs e)
        {
            try
            {
                FolderBrowserDialog fbd = new FolderBrowserDialog();
                fbd.RootFolder = Environment.SpecialFolder.Desktop;
                fbd.ShowNewFolderButton = false;

                if (fbd.ShowDialog() == DialogResult.OK)
                {
                    txtCarpeta.Text = fbd.SelectedPath;
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error al seleccionar la carpeta para instalar AO-YIND.");
            }
           
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                if (Directory.Exists(txtCarpeta.Text))
                {
                    WebClient Client = new WebClient();
                    Client.DownloadFile("http://www.aoyind.com/aoyind.rar", @"" + txtCarpeta.Text + "\aoyind.rar");
                }
                else
                {
                    MessageBox.Show("La carpeta no existe. Por favor, seleccionar otra carpeta.");
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error al descargar AO-YIND desde el servidor.");
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
