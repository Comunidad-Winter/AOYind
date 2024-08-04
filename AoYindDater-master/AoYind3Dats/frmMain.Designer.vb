<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class frmMain
    Inherits System.Windows.Forms.Form

    'Form reemplaza a Dispose para limpiar la lista de componentes.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Requerido por el Diseñador de Windows Forms
    Private components As System.ComponentModel.IContainer

    'NOTA: el Diseñador de Windows Forms necesita el siguiente procedimiento
    'Se puede modificar usando el Diseñador de Windows Forms.  
    'No lo modifique con el editor de código.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.tFiltro = New System.Windows.Forms.ComboBox()
        Me.tBuscador = New System.Windows.Forms.TextBox()
        Me.tResults = New System.Windows.Forms.ListBox()
        Me.TabControl1 = New System.Windows.Forms.TabControl()
        Me.tabAreas = New System.Windows.Forms.TabPage()
        Me.tabArmas = New System.Windows.Forms.TabPage()
        Me.tabCabezas = New System.Windows.Forms.TabPage()
        Me.tabCarpintero = New System.Windows.Forms.TabPage()
        Me.tabCascos = New System.Windows.Forms.TabPage()
        Me.tabCuerpos = New System.Windows.Forms.TabPage()
        Me.tabEscudos = New System.Windows.Forms.TabPage()
        Me.tabFX = New System.Windows.Forms.TabPage()
        Me.tabGraficos = New System.Windows.Forms.TabPage()
        Me.tabHechizos = New System.Windows.Forms.TabPage()
        Me.tabHerrero = New System.Windows.Forms.TabPage()
        Me.tabIndexacion = New System.Windows.Forms.TabPage()
        Me.tabNpcs = New System.Windows.Forms.TabPage()
        Me.tabObjetos = New System.Windows.Forms.TabPage()
        Me.tabZonas = New System.Windows.Forms.TabPage()
        Me.SplitContainer2 = New System.Windows.Forms.SplitContainer()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.pPreview = New System.Windows.Forms.PictureBox()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.tAreaMapa = New System.Windows.Forms.TextBox()
        Me.tAreaNombre = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.tAreaId = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.tAreaX1 = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.tAreaY1 = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.tAreaY2 = New System.Windows.Forms.TextBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.tAreaX2 = New System.Windows.Forms.TextBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.btnCancelar = New System.Windows.Forms.Button()
        Me.tAreaNpcs = New System.Windows.Forms.ListBox()
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip()
        Me.tAreaAddNpc = New System.Windows.Forms.ToolStripButton()
        Me.tAreaRemoveNpc = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel()
        Me.btnNuevo = New System.Windows.Forms.Button()
        Me.btnGuardar = New System.Windows.Forms.Button()
        Me.Panel3 = New System.Windows.Forms.Panel()
        Me.btnBorrar = New System.Windows.Forms.Button()
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.TabControl1.SuspendLayout()
        Me.tabAreas.SuspendLayout()
        CType(Me.SplitContainer2, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer2.Panel1.SuspendLayout()
        Me.SplitContainer2.Panel2.SuspendLayout()
        Me.SplitContainer2.SuspendLayout()
        CType(Me.pPreview, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel2.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.Panel3.SuspendLayout()
        Me.SuspendLayout()
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer1.Name = "SplitContainer1"
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.tResults)
        Me.SplitContainer1.Panel1.Controls.Add(Me.tBuscador)
        Me.SplitContainer1.Panel1.Controls.Add(Me.tFiltro)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.SplitContainer2)
        Me.SplitContainer1.Size = New System.Drawing.Size(1343, 639)
        Me.SplitContainer1.SplitterDistance = 285
        Me.SplitContainer1.TabIndex = 0
        '
        'tFiltro
        '
        Me.tFiltro.Dock = System.Windows.Forms.DockStyle.Top
        Me.tFiltro.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.tFiltro.FormattingEnabled = True
        Me.tFiltro.Items.AddRange(New Object() {"Areas", "Armas", "Cabezas", "Carpintero", "Cascos", "Cuerpos", "Escudos", "FX", "Graficos", "Hechizos", "Herrero", "Indexacion", "NPCs", "Objetos", "Zonas"})
        Me.tFiltro.Location = New System.Drawing.Point(0, 0)
        Me.tFiltro.Name = "tFiltro"
        Me.tFiltro.Size = New System.Drawing.Size(285, 21)
        Me.tFiltro.TabIndex = 0
        '
        'tBuscador
        '
        Me.tBuscador.Dock = System.Windows.Forms.DockStyle.Top
        Me.tBuscador.Location = New System.Drawing.Point(0, 21)
        Me.tBuscador.Name = "tBuscador"
        Me.tBuscador.Size = New System.Drawing.Size(285, 21)
        Me.tBuscador.TabIndex = 1
        '
        'tResults
        '
        Me.tResults.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tResults.FormattingEnabled = True
        Me.tResults.Location = New System.Drawing.Point(0, 42)
        Me.tResults.Name = "tResults"
        Me.tResults.Size = New System.Drawing.Size(285, 597)
        Me.tResults.TabIndex = 2
        '
        'TabControl1
        '
        Me.TabControl1.Controls.Add(Me.tabAreas)
        Me.TabControl1.Controls.Add(Me.tabArmas)
        Me.TabControl1.Controls.Add(Me.tabCabezas)
        Me.TabControl1.Controls.Add(Me.tabCarpintero)
        Me.TabControl1.Controls.Add(Me.tabCascos)
        Me.TabControl1.Controls.Add(Me.tabCuerpos)
        Me.TabControl1.Controls.Add(Me.tabEscudos)
        Me.TabControl1.Controls.Add(Me.tabFX)
        Me.TabControl1.Controls.Add(Me.tabGraficos)
        Me.TabControl1.Controls.Add(Me.tabHechizos)
        Me.TabControl1.Controls.Add(Me.tabHerrero)
        Me.TabControl1.Controls.Add(Me.tabIndexacion)
        Me.TabControl1.Controls.Add(Me.tabNpcs)
        Me.TabControl1.Controls.Add(Me.tabObjetos)
        Me.TabControl1.Controls.Add(Me.tabZonas)
        Me.TabControl1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl1.Location = New System.Drawing.Point(0, 0)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(797, 598)
        Me.TabControl1.TabIndex = 0
        '
        'tabAreas
        '
        Me.tabAreas.Controls.Add(Me.Panel2)
        Me.tabAreas.Controls.Add(Me.tAreaY2)
        Me.tabAreas.Controls.Add(Me.Label7)
        Me.tabAreas.Controls.Add(Me.tAreaX2)
        Me.tabAreas.Controls.Add(Me.Label8)
        Me.tabAreas.Controls.Add(Me.tAreaY1)
        Me.tabAreas.Controls.Add(Me.Label6)
        Me.tabAreas.Controls.Add(Me.tAreaX1)
        Me.tabAreas.Controls.Add(Me.Label5)
        Me.tabAreas.Controls.Add(Me.tAreaId)
        Me.tabAreas.Controls.Add(Me.Label4)
        Me.tabAreas.Controls.Add(Me.tAreaNombre)
        Me.tabAreas.Controls.Add(Me.Label3)
        Me.tabAreas.Controls.Add(Me.tAreaMapa)
        Me.tabAreas.Controls.Add(Me.Label2)
        Me.tabAreas.Location = New System.Drawing.Point(4, 22)
        Me.tabAreas.Name = "tabAreas"
        Me.tabAreas.Padding = New System.Windows.Forms.Padding(3)
        Me.tabAreas.Size = New System.Drawing.Size(789, 572)
        Me.tabAreas.TabIndex = 0
        Me.tabAreas.Text = "Areas"
        Me.tabAreas.UseVisualStyleBackColor = True
        '
        'tabArmas
        '
        Me.tabArmas.Location = New System.Drawing.Point(4, 22)
        Me.tabArmas.Name = "tabArmas"
        Me.tabArmas.Padding = New System.Windows.Forms.Padding(3)
        Me.tabArmas.Size = New System.Drawing.Size(775, 613)
        Me.tabArmas.TabIndex = 1
        Me.tabArmas.Text = "Armas"
        Me.tabArmas.UseVisualStyleBackColor = True
        '
        'tabCabezas
        '
        Me.tabCabezas.Location = New System.Drawing.Point(4, 22)
        Me.tabCabezas.Name = "tabCabezas"
        Me.tabCabezas.Size = New System.Drawing.Size(775, 613)
        Me.tabCabezas.TabIndex = 2
        Me.tabCabezas.Text = "Cabezas"
        Me.tabCabezas.UseVisualStyleBackColor = True
        '
        'tabCarpintero
        '
        Me.tabCarpintero.Location = New System.Drawing.Point(4, 22)
        Me.tabCarpintero.Name = "tabCarpintero"
        Me.tabCarpintero.Size = New System.Drawing.Size(775, 613)
        Me.tabCarpintero.TabIndex = 3
        Me.tabCarpintero.Text = "Carpintero"
        Me.tabCarpintero.UseVisualStyleBackColor = True
        '
        'tabCascos
        '
        Me.tabCascos.Location = New System.Drawing.Point(4, 22)
        Me.tabCascos.Name = "tabCascos"
        Me.tabCascos.Size = New System.Drawing.Size(775, 613)
        Me.tabCascos.TabIndex = 4
        Me.tabCascos.Text = "Cascos"
        Me.tabCascos.UseVisualStyleBackColor = True
        '
        'tabCuerpos
        '
        Me.tabCuerpos.Location = New System.Drawing.Point(4, 22)
        Me.tabCuerpos.Name = "tabCuerpos"
        Me.tabCuerpos.Size = New System.Drawing.Size(775, 613)
        Me.tabCuerpos.TabIndex = 5
        Me.tabCuerpos.Text = "Cuerpos"
        Me.tabCuerpos.UseVisualStyleBackColor = True
        '
        'tabEscudos
        '
        Me.tabEscudos.Location = New System.Drawing.Point(4, 22)
        Me.tabEscudos.Name = "tabEscudos"
        Me.tabEscudos.Size = New System.Drawing.Size(775, 613)
        Me.tabEscudos.TabIndex = 6
        Me.tabEscudos.Text = "Escudos"
        Me.tabEscudos.UseVisualStyleBackColor = True
        '
        'tabFX
        '
        Me.tabFX.Location = New System.Drawing.Point(4, 22)
        Me.tabFX.Name = "tabFX"
        Me.tabFX.Size = New System.Drawing.Size(775, 613)
        Me.tabFX.TabIndex = 7
        Me.tabFX.Text = "FX"
        Me.tabFX.UseVisualStyleBackColor = True
        '
        'tabGraficos
        '
        Me.tabGraficos.Location = New System.Drawing.Point(4, 22)
        Me.tabGraficos.Name = "tabGraficos"
        Me.tabGraficos.Size = New System.Drawing.Size(775, 613)
        Me.tabGraficos.TabIndex = 8
        Me.tabGraficos.Text = "Graficos"
        Me.tabGraficos.UseVisualStyleBackColor = True
        '
        'tabHechizos
        '
        Me.tabHechizos.Location = New System.Drawing.Point(4, 22)
        Me.tabHechizos.Name = "tabHechizos"
        Me.tabHechizos.Size = New System.Drawing.Size(775, 613)
        Me.tabHechizos.TabIndex = 9
        Me.tabHechizos.Text = "Hechizos"
        Me.tabHechizos.UseVisualStyleBackColor = True
        '
        'tabHerrero
        '
        Me.tabHerrero.Location = New System.Drawing.Point(4, 22)
        Me.tabHerrero.Name = "tabHerrero"
        Me.tabHerrero.Size = New System.Drawing.Size(775, 613)
        Me.tabHerrero.TabIndex = 10
        Me.tabHerrero.Text = "Herrero"
        Me.tabHerrero.UseVisualStyleBackColor = True
        '
        'tabIndexacion
        '
        Me.tabIndexacion.Location = New System.Drawing.Point(4, 22)
        Me.tabIndexacion.Name = "tabIndexacion"
        Me.tabIndexacion.Size = New System.Drawing.Size(775, 613)
        Me.tabIndexacion.TabIndex = 11
        Me.tabIndexacion.Text = "Indexacion"
        Me.tabIndexacion.UseVisualStyleBackColor = True
        '
        'tabNpcs
        '
        Me.tabNpcs.Location = New System.Drawing.Point(4, 22)
        Me.tabNpcs.Name = "tabNpcs"
        Me.tabNpcs.Size = New System.Drawing.Size(775, 613)
        Me.tabNpcs.TabIndex = 12
        Me.tabNpcs.Text = "NPCs"
        Me.tabNpcs.UseVisualStyleBackColor = True
        '
        'tabObjetos
        '
        Me.tabObjetos.Location = New System.Drawing.Point(4, 22)
        Me.tabObjetos.Name = "tabObjetos"
        Me.tabObjetos.Size = New System.Drawing.Size(775, 613)
        Me.tabObjetos.TabIndex = 13
        Me.tabObjetos.Text = "Objetos"
        Me.tabObjetos.UseVisualStyleBackColor = True
        '
        'tabZonas
        '
        Me.tabZonas.Location = New System.Drawing.Point(4, 22)
        Me.tabZonas.Name = "tabZonas"
        Me.tabZonas.Size = New System.Drawing.Size(775, 613)
        Me.tabZonas.TabIndex = 14
        Me.tabZonas.Text = "Zonas"
        Me.tabZonas.UseVisualStyleBackColor = True
        '
        'SplitContainer2
        '
        Me.SplitContainer2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer2.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer2.Name = "SplitContainer2"
        '
        'SplitContainer2.Panel1
        '
        Me.SplitContainer2.Panel1.Controls.Add(Me.TabControl1)
        Me.SplitContainer2.Panel1.Controls.Add(Me.Panel3)
        '
        'SplitContainer2.Panel2
        '
        Me.SplitContainer2.Panel2.BackColor = System.Drawing.Color.White
        Me.SplitContainer2.Panel2.Controls.Add(Me.pPreview)
        Me.SplitContainer2.Panel2.Controls.Add(Me.Panel1)
        Me.SplitContainer2.Panel2.Controls.Add(Me.Label1)
        Me.SplitContainer2.Size = New System.Drawing.Size(1054, 639)
        Me.SplitContainer2.SplitterDistance = 797
        Me.SplitContainer2.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.Color.WhiteSmoke
        Me.Label1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Label1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(0, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(253, 27)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Preview"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pPreview
        '
        Me.pPreview.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pPreview.Location = New System.Drawing.Point(0, 27)
        Me.pPreview.Name = "pPreview"
        Me.pPreview.Size = New System.Drawing.Size(253, 479)
        Me.pPreview.TabIndex = 1
        Me.pPreview.TabStop = False
        '
        'Panel1
        '
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel1.Location = New System.Drawing.Point(0, 506)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(253, 133)
        Me.Panel1.TabIndex = 2
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 47)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(37, 13)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Mapa:"
        '
        'tAreaMapa
        '
        Me.tAreaMapa.Location = New System.Drawing.Point(9, 63)
        Me.tAreaMapa.Name = "tAreaMapa"
        Me.tAreaMapa.Size = New System.Drawing.Size(100, 21)
        Me.tAreaMapa.TabIndex = 1
        '
        'tAreaNombre
        '
        Me.tAreaNombre.Location = New System.Drawing.Point(9, 103)
        Me.tAreaNombre.Name = "tAreaNombre"
        Me.tAreaNombre.Size = New System.Drawing.Size(244, 21)
        Me.tAreaNombre.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(6, 87)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(48, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Nombre:"
        '
        'tAreaId
        '
        Me.tAreaId.Location = New System.Drawing.Point(9, 23)
        Me.tAreaId.Name = "tAreaId"
        Me.tAreaId.Size = New System.Drawing.Size(100, 21)
        Me.tAreaId.TabIndex = 5
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(6, 7)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(21, 13)
        Me.Label4.TabIndex = 4
        Me.Label4.Text = "Id:"
        '
        'tAreaX1
        '
        Me.tAreaX1.Location = New System.Drawing.Point(9, 172)
        Me.tAreaX1.Name = "tAreaX1"
        Me.tAreaX1.Size = New System.Drawing.Size(77, 21)
        Me.tAreaX1.TabIndex = 8
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(6, 156)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(23, 13)
        Me.Label5.TabIndex = 7
        Me.Label5.Text = "X1:"
        '
        'tAreaY1
        '
        Me.tAreaY1.Location = New System.Drawing.Point(92, 172)
        Me.tAreaY1.Name = "tAreaY1"
        Me.tAreaY1.Size = New System.Drawing.Size(77, 21)
        Me.tAreaY1.TabIndex = 10
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(89, 156)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(23, 13)
        Me.Label6.TabIndex = 9
        Me.Label6.Text = "Y1:"
        '
        'tAreaY2
        '
        Me.tAreaY2.Location = New System.Drawing.Point(92, 212)
        Me.tAreaY2.Name = "tAreaY2"
        Me.tAreaY2.Size = New System.Drawing.Size(77, 21)
        Me.tAreaY2.TabIndex = 14
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(89, 196)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(23, 13)
        Me.Label7.TabIndex = 13
        Me.Label7.Text = "Y2:"
        '
        'tAreaX2
        '
        Me.tAreaX2.Location = New System.Drawing.Point(9, 212)
        Me.tAreaX2.Name = "tAreaX2"
        Me.tAreaX2.Size = New System.Drawing.Size(77, 21)
        Me.tAreaX2.TabIndex = 12
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(6, 196)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(23, 13)
        Me.Label8.TabIndex = 11
        Me.Label8.Text = "X2:"
        '
        'btnCancelar
        '
        Me.btnCancelar.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancelar.Location = New System.Drawing.Point(555, 6)
        Me.btnCancelar.Name = "btnCancelar"
        Me.btnCancelar.Size = New System.Drawing.Size(113, 28)
        Me.btnCancelar.TabIndex = 15
        Me.btnCancelar.Text = "Cancelar"
        Me.btnCancelar.UseVisualStyleBackColor = True
        '
        'tAreaNpcs
        '
        Me.tAreaNpcs.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tAreaNpcs.FormattingEnabled = True
        Me.tAreaNpcs.Location = New System.Drawing.Point(0, 25)
        Me.tAreaNpcs.Name = "tAreaNpcs"
        Me.tAreaNpcs.Size = New System.Drawing.Size(527, 532)
        Me.tAreaNpcs.TabIndex = 16
        '
        'Panel2
        '
        Me.Panel2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel2.Controls.Add(Me.tAreaNpcs)
        Me.Panel2.Controls.Add(Me.ToolStrip1)
        Me.Panel2.Location = New System.Drawing.Point(259, 7)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(527, 557)
        Me.Panel2.TabIndex = 18
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1, Me.tAreaAddNpc, Me.tAreaRemoveNpc})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(527, 25)
        Me.ToolStrip1.TabIndex = 0
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'tAreaAddNpc
        '
        Me.tAreaAddNpc.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.tAreaAddNpc.Image = Global.AoYind3Dats.My.Resources.Resources.add
        Me.tAreaAddNpc.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.tAreaAddNpc.Name = "tAreaAddNpc"
        Me.tAreaAddNpc.Size = New System.Drawing.Size(23, 22)
        Me.tAreaAddNpc.Text = "Agregar npc a la area"
        '
        'tAreaRemoveNpc
        '
        Me.tAreaRemoveNpc.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.tAreaRemoveNpc.Image = Global.AoYind3Dats.My.Resources.Resources.delete
        Me.tAreaRemoveNpc.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.tAreaRemoveNpc.Name = "tAreaRemoveNpc"
        Me.tAreaRemoveNpc.Size = New System.Drawing.Size(23, 22)
        Me.tAreaRemoveNpc.Text = "Quitar Npc seleccionado"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(36, 22)
        Me.ToolStripLabel1.Text = "NPCs"
        '
        'btnNuevo
        '
        Me.btnNuevo.Location = New System.Drawing.Point(7, 6)
        Me.btnNuevo.Name = "btnNuevo"
        Me.btnNuevo.Size = New System.Drawing.Size(113, 28)
        Me.btnNuevo.TabIndex = 19
        Me.btnNuevo.Text = "Nuevo"
        Me.btnNuevo.UseVisualStyleBackColor = True
        '
        'btnGuardar
        '
        Me.btnGuardar.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnGuardar.Location = New System.Drawing.Point(674, 6)
        Me.btnGuardar.Name = "btnGuardar"
        Me.btnGuardar.Size = New System.Drawing.Size(113, 28)
        Me.btnGuardar.TabIndex = 20
        Me.btnGuardar.Text = "Guardar cambios"
        Me.btnGuardar.UseVisualStyleBackColor = True
        '
        'Panel3
        '
        Me.Panel3.BackColor = System.Drawing.Color.White
        Me.Panel3.Controls.Add(Me.btnBorrar)
        Me.Panel3.Controls.Add(Me.btnNuevo)
        Me.Panel3.Controls.Add(Me.btnGuardar)
        Me.Panel3.Controls.Add(Me.btnCancelar)
        Me.Panel3.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel3.Location = New System.Drawing.Point(0, 598)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(797, 41)
        Me.Panel3.TabIndex = 1
        '
        'btnBorrar
        '
        Me.btnBorrar.Location = New System.Drawing.Point(126, 6)
        Me.btnBorrar.Name = "btnBorrar"
        Me.btnBorrar.Size = New System.Drawing.Size(113, 28)
        Me.btnBorrar.TabIndex = 21
        Me.btnBorrar.Text = "Borrar"
        Me.btnBorrar.UseVisualStyleBackColor = True
        '
        'frmMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1343, 639)
        Me.Controls.Add(Me.SplitContainer1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "frmMain"
        Me.Text = "Indexador AoYind 3"
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel1.PerformLayout()
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer1.ResumeLayout(False)
        Me.TabControl1.ResumeLayout(False)
        Me.tabAreas.ResumeLayout(False)
        Me.tabAreas.PerformLayout()
        Me.SplitContainer2.Panel1.ResumeLayout(False)
        Me.SplitContainer2.Panel2.ResumeLayout(False)
        CType(Me.SplitContainer2, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer2.ResumeLayout(False)
        CType(Me.pPreview, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel2.ResumeLayout(False)
        Me.Panel2.PerformLayout()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.Panel3.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents SplitContainer1 As SplitContainer
    Friend WithEvents tResults As ListBox
    Friend WithEvents tBuscador As TextBox
    Friend WithEvents tFiltro As ComboBox
    Friend WithEvents TabControl1 As TabControl
    Friend WithEvents tabAreas As TabPage
    Friend WithEvents tabArmas As TabPage
    Friend WithEvents tabCabezas As TabPage
    Friend WithEvents tabCarpintero As TabPage
    Friend WithEvents tabCascos As TabPage
    Friend WithEvents tabCuerpos As TabPage
    Friend WithEvents tabEscudos As TabPage
    Friend WithEvents tabFX As TabPage
    Friend WithEvents tabGraficos As TabPage
    Friend WithEvents tabHechizos As TabPage
    Friend WithEvents tabHerrero As TabPage
    Friend WithEvents tabIndexacion As TabPage
    Friend WithEvents tabNpcs As TabPage
    Friend WithEvents tabObjetos As TabPage
    Friend WithEvents tabZonas As TabPage
    Friend WithEvents SplitContainer2 As SplitContainer
    Friend WithEvents Label1 As Label
    Friend WithEvents pPreview As PictureBox
    Friend WithEvents Panel1 As Panel
    Friend WithEvents tAreaId As TextBox
    Friend WithEvents Label4 As Label
    Friend WithEvents tAreaNombre As TextBox
    Friend WithEvents Label3 As Label
    Friend WithEvents tAreaMapa As TextBox
    Friend WithEvents Label2 As Label
    Friend WithEvents btnCancelar As Button
    Friend WithEvents tAreaY2 As TextBox
    Friend WithEvents Label7 As Label
    Friend WithEvents tAreaX2 As TextBox
    Friend WithEvents Label8 As Label
    Friend WithEvents tAreaY1 As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents tAreaX1 As TextBox
    Friend WithEvents Label5 As Label
    Friend WithEvents tAreaNpcs As ListBox
    Friend WithEvents Panel2 As Panel
    Friend WithEvents ToolStrip1 As ToolStrip
    Friend WithEvents tAreaAddNpc As ToolStripButton
    Friend WithEvents tAreaRemoveNpc As ToolStripButton
    Friend WithEvents ToolStripLabel1 As ToolStripLabel
    Friend WithEvents Panel3 As Panel
    Friend WithEvents btnNuevo As Button
    Friend WithEvents btnGuardar As Button
    Friend WithEvents btnBorrar As Button
End Class
