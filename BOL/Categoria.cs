using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DAL;

namespace BOL
{
    public class Categoria
    {
        DBAccess acceso = new DBAccess();

        public DataTable listarCategorias()
        {
            DataTable data = new DataTable();

            acceso.abriConexion();
            SqlDataAdapter command = new SqlDataAdapter("", acceso.getConexion());
            command.Fill(data);
            acceso.cerrarConexion();

            return data;
        }

        public int registrarCategoria(string categoria)
        {
            int filasAfectadas = 0;
            SqlCommand command = new SqlCommand("", acceso.getConexion());
            command.CommandType = CommandType.StoredProcedure;

            try
            {
                acceso.abriConexion();

                command.Parameters.AddWithValue("@categoria", categoria);
                filasAfectadas = command.ExecuteNonQuery();

                acceso.cerrarConexion();
                return filasAfectadas;
            }
            catch
            {
                return -1;
            }
        }

        public int editarCategoria(string categoria)
        {
            int filasAfectadas = 0;
            SqlCommand command = new SqlCommand("", acceso.getConexion());
            command.CommandType = CommandType.StoredProcedure;

            try
            {
                acceso.abriConexion();

                command.Parameters.AddWithValue("@categoria", categoria);
                filasAfectadas = command.ExecuteNonQuery();

                acceso.cerrarConexion();
                return filasAfectadas;
            } 
            catch
            {
                return -1;
            }
        }
    }
}
