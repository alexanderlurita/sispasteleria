using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//1. Importando librerias
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    //2. Establecer la clase como pública
    public class DBAccess
    {
        //3. Objeto de conexión a MSSQL Server
        SqlConnection conexion = new SqlConnection("data source=.;database=PASTELERIA;user id=sa;password=123456;integrated security=true");
        
        //4. Métodos de acceso
        public SqlConnection getConexion()
        {
            return conexion; 
        }

        //5. Abrir la conexión
        public void abriConexion()
        {
            if (conexion.State == ConnectionState.Closed)
            {
                conexion.Open();
            }
        }

        //6. Cerrar conexión
        public void cerrarConexion()
        {
            if (conexion.State == ConnectionState.Open)
            {
                conexion.Close();
            }
        }
    }
}
