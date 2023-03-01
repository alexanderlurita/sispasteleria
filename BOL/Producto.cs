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
    public class Producto
    {
        DBAccess acceso = new DBAccess();

        public DataTable listarProductos()
        {
            DataTable data = new DataTable();

            acceso.abriConexion();
            SqlDataAdapter command = new SqlDataAdapter("", acceso.getConexion());
            command.Fill(data);
            acceso.cerrarConexion();

            return data;
        }

        public int registrarProducto(int idcategoria, string nombreproducto, string descripcion, DateTime fechaelaboracion, float precio, int stock)
        {
            int filasAfectadas = 0;
            SqlCommand command = new SqlCommand("", acceso.getConexion());
            command.CommandType = CommandType.StoredProcedure;

            try
            {
                acceso.abriConexion();

                command.Parameters.AddWithValue("@idcategoria", idcategoria);
                command.Parameters.AddWithValue("@nombreproducto", nombreproducto);
                command.Parameters.AddWithValue("@descripcion", descripcion);
                command.Parameters.AddWithValue("@fechaelaboracion", fechaelaboracion);
                command.Parameters.AddWithValue("@precio", precio);
                command.Parameters.AddWithValue("@stock", stock);
                filasAfectadas = command.ExecuteNonQuery();

                acceso.cerrarConexion();
                return filasAfectadas;
            }
            catch
            {
                return -1;
            }

        }

        public int editarProducto(int idproducto, int idcategoria, string nombreproducto, string descripcion, DateTime fechaelaboracion, float precio, int stock)
        {
            int filasAfectadas = 0;
            SqlCommand command = new SqlCommand("", acceso.getConexion());
            command.CommandType = CommandType.StoredProcedure;

            try
            {
                acceso.abriConexion();

                command.Parameters.AddWithValue("@idproducto", idproducto);
                command.Parameters.AddWithValue("@idcategoria", idcategoria);
                command.Parameters.AddWithValue("@nombreproducto", nombreproducto);
                command.Parameters.AddWithValue("@descripcion", descripcion);
                command.Parameters.AddWithValue("@fechaelaboracion", fechaelaboracion);
                command.Parameters.AddWithValue("@precio", precio);
                command.Parameters.AddWithValue("@stock", stock);
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
