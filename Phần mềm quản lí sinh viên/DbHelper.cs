using System.Configuration;
using System.Data;
using Microsoft.Data.SqlClient;

namespace Phần_mềm_quản_lí_sinh_viên
{
    public static class DbHelper
    {
        private static string ConnectionString =>
            ConfigurationManager.ConnectionStrings["QLSV"].ConnectionString;

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        public static DataTable ExecuteQuery(string sql, params SqlParameter[] parameters)
        {
            using var conn = GetConnection();
            using var cmd = new SqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);

            var table = new DataTable();
            using var adapter = new SqlDataAdapter(cmd);
            adapter.Fill(table);
            return table;
        }

        public static int ExecuteNonQuery(string sql, params SqlParameter[] parameters)
        {
            using var conn = GetConnection();
            using var cmd = new SqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);

            conn.Open();
            return cmd.ExecuteNonQuery();
        }

        public static object? ExecuteScalar(string sql, params SqlParameter[] parameters)
        {
            using var conn = GetConnection();
            using var cmd = new SqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);

            conn.Open();
            return cmd.ExecuteScalar();
        }

        public static bool TestConnection(out string error)
        {
            try
            {
                using var conn = GetConnection();
                conn.Open();
                error = "";
                return true;
            }
            catch (System.Exception ex)
            {
                error = ex.Message;
                return false;
            }
        }
    }
}
