using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Phần_mềm_quản_lí_sinh_viên
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (!DbHelper.TestConnection(out string loi))
            {
                MessageBox.Show("Không kết nối được database:\n" + loi);
                return;
            }
            dgvSinhVien.DataSource = DbHelper.ExecuteQuery("SELECT * FROM SinhVien");
        }
    }
}
