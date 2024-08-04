using System;
using System.Collections.Generic;
using System.Text;

namespace EstadoServidor
{
    public class Servidor
    {
        public  string estado;
        public  int cantidad_online;
        public  string hora;
        public int cantidad_pj;

        public Servidor()
        {
            estado = "OFFLINE";
            cantidad_online = 0;
            hora = "";
            cantidad_pj = 0;
        }
    }
}
