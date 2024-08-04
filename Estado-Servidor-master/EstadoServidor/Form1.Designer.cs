
namespace EstadoServidor
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.lblUltimaActualizacion = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.lblEstado = new System.Windows.Forms.Label();
            this.btnServerOnline = new System.Windows.Forms.Button();
            this.btnServerOff = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.label1.Location = new System.Drawing.Point(12, 22);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(190, 21);
            this.label1.TabIndex = 0;
            this.label1.Text = "ÚLTIMA ACTUALIZACIÓN:";
            // 
            // lblUltimaActualizacion
            // 
            this.lblUltimaActualizacion.AutoSize = true;
            this.lblUltimaActualizacion.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.lblUltimaActualizacion.Location = new System.Drawing.Point(30, 47);
            this.lblUltimaActualizacion.Name = "lblUltimaActualizacion";
            this.lblUltimaActualizacion.Size = new System.Drawing.Size(22, 21);
            this.lblUltimaActualizacion.TabIndex = 1;
            this.lblUltimaActualizacion.Text = "--";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 279);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(228, 15);
            this.label3.TabIndex = 2;
            this.label3.Text = "Desarrollado por Jota (Juan Pablo Pereyra)";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.label2.Location = new System.Drawing.Point(12, 87);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(159, 19);
            this.label2.TabIndex = 3;
            this.label2.Text = "ESTADO DEL SERVIDOR:";
            // 
            // lblEstado
            // 
            this.lblEstado.AutoSize = true;
            this.lblEstado.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.lblEstado.Location = new System.Drawing.Point(30, 115);
            this.lblEstado.Name = "lblEstado";
            this.lblEstado.Size = new System.Drawing.Size(21, 19);
            this.lblEstado.TabIndex = 4;
            this.lblEstado.Text = "--";
            // 
            // btnServerOnline
            // 
            this.btnServerOnline.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.btnServerOnline.ForeColor = System.Drawing.Color.DarkGreen;
            this.btnServerOnline.Location = new System.Drawing.Point(12, 158);
            this.btnServerOnline.Name = "btnServerOnline";
            this.btnServerOnline.Size = new System.Drawing.Size(249, 30);
            this.btnServerOnline.TabIndex = 5;
            this.btnServerOnline.Text = "SERVIDOR ONLINE";
            this.btnServerOnline.UseVisualStyleBackColor = true;
            this.btnServerOnline.Click += new System.EventHandler(this.btnServerOnline_Click);
            // 
            // btnServerOff
            // 
            this.btnServerOff.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.btnServerOff.ForeColor = System.Drawing.Color.DarkRed;
            this.btnServerOff.Location = new System.Drawing.Point(12, 228);
            this.btnServerOff.Name = "btnServerOff";
            this.btnServerOff.Size = new System.Drawing.Size(249, 30);
            this.btnServerOff.TabIndex = 6;
            this.btnServerOff.Text = "SERVIDOR OFFLINE";
            this.btnServerOff.UseVisualStyleBackColor = true;
            this.btnServerOff.Click += new System.EventHandler(this.btnServerOff_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(273, 303);
            this.Controls.Add(this.btnServerOff);
            this.Controls.Add(this.btnServerOnline);
            this.Controls.Add(this.lblEstado);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.lblUltimaActualizacion);
            this.Controls.Add(this.label1);
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Estado servidor AO-YIND";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblUltimaActualizacion;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label lblEstado;
        private System.Windows.Forms.Button btnServerOnline;
        private System.Windows.Forms.Button btnServerOff;
    }
}

