Attribute VB_Name = "modMapIO"
'**************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the GNU General Public License as published by
'the Free Software Foundation; either version 2 of the License, or
'any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'**************************************************************

''
' modMapIO
'
' @remarks Funciones Especificas al trabajo con Archivos de Mapas
' @author gshaxor@gmail.com
' @version 0.1.15
' @date 20060602

Option Explicit
Private MapTitulo As String     ' GS > Almacena el titulo del mapa para el .dat

''
' Obtener el tamaño de un archivo
'
' @param FileName Especifica el path del archivo
' @return   Nos devuelve el tamaño

Public Function FileSize(ByVal FileName As String) As Long
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************

    On Error GoTo FalloFile
    Dim nFileNum As Integer
    Dim lFileSize As Long
    
    nFileNum = FreeFile
    Open FileName For Input As nFileNum
    lFileSize = LOF(nFileNum)
    Close nFileNum
    FileSize = lFileSize
    
    Exit Function
FalloFile:
    FileSize = -1
End Function

''
' Nos dice si existe el archivo/directorio
'
' @param file Especifica el path
' @param FileType Especifica el tipo de archivo/directorio
' @return   Nos devuelve verdadero o falso

Public Function FileExist(ByVal file As String, ByVal FileType As VbFileAttribute) As Boolean
'*************************************************
'Author: Unkwown
'Last modified: 26/05/06
'*************************************************
If LenB(Dir(file, FileType)) = 0 Then
    FileExist = False
Else
    FileExist = True
End If

End Function



''
' Limpia todo el mapa a uno nuevo
'

Public Sub NuevoMapa()
'*************************************************
'Author: ^[GS]^
'Last modified: 21/05/06
'*************************************************

On Error Resume Next

Dim loopc As Integer
Dim Y As Integer
Dim X As Integer

bAutoGuardarMapaCount = 0

'frmMain.mnuUtirialNuevoFormato.Checked = True
'frmMain.mnuReAbrirMapa.Enabled = False
'frmMain.TimAutoGuardarMapa.Enabled = False
'frmMain.lblMapVersion.Caption = 0

MapaCargado = False


frmMain.MousePointer = 11

ReDim MapData(UserMap).Tile(1 To MapInfo(CurrentMap).Width, 1 To MapInfo(CurrentMap).Height)

For Y = YMinMapSize To MapInfo(CurrentMap).Height
    For X = XMinMapSize To MapInfo(CurrentMap).Width
    
        ' Capa 1
        MapData(CurrentMap).Tile(X, Y).Graphic(1).grhindex = 1
        
        ' Bloqueos
        MapData(CurrentMap).Tile(X, Y).Blocked = 0

        ' Capas 2, 3 y 4
        MapData(CurrentMap).Tile(X, Y).Graphic(2).grhindex = 0
        MapData(CurrentMap).Tile(X, Y).Graphic(3).grhindex = 0
        MapData(CurrentMap).Tile(X, Y).Graphic(4).grhindex = 0

        ' NPCs
        If MapData(CurrentMap).Tile(X, Y).NPCIndex > 0 Then
            EraseChar MapData(CurrentMap).Tile(X, Y).CharIndex
            MapData(CurrentMap).Tile(X, Y).NPCIndex = 0
        End If

        ' OBJs
        MapData(CurrentMap).Tile(X, Y).OBJInfo.OBJIndex = 0
        MapData(CurrentMap).Tile(X, Y).OBJInfo.Amount = 0
        MapData(CurrentMap).Tile(X, Y).ObjGrh.grhindex = 0

        ' Translados
        MapData(CurrentMap).Tile(X, Y).TileExit.Map = 0
        MapData(CurrentMap).Tile(X, Y).TileExit.X = 0
        MapData(CurrentMap).Tile(X, Y).TileExit.Y = 0
        
        ' Triggers
        MapData(CurrentMap).Tile(X, Y).Trigger = 0
        
        InitGrh MapData(CurrentMap).Tile(X, Y).Graphic(1), 1
    Next X
Next Y

MapInfo(CurrentMap).MapVersion = 0
MapInfo(CurrentMap).name = "Nuevo Mapa"



Call MapInfo_Actualizar

bRefreshRadar = True ' Radar

'Set changed flag
MapInfo(CurrentMap).Changed = 0
frmMain.MousePointer = 0


MapaCargado = True
EngineRun = True

frmMain.SetFocus

End Sub

''
' Actualiza el formulario de MapInfo
'

Public Sub MapInfo_Actualizar()
'*************************************************
'Author: ^[GS]^
'Last modified: 02/06/06
'*************************************************

On Error Resume Next
    ' Mostrar en Formularios
    frmMapInfo.txtMapNombre.text = MapInfo(CurrentMap).name
    frmMapInfo.txtMapVersion = MapInfo(CurrentMap).MapVersion
    frmMapInfo.tWidth = MapInfo(CurrentMap).Width
    frmMapInfo.tHeight = MapInfo(CurrentMap).Height
    'frmMain.lblMapNombre = mapinfo(currentmap).name
    'frmMain.lblMapMusica = mapinfo(currentmap).Music
    
    frmMain.lMap.Caption = "Mapa " & UserMap & " - " & MapInfo(CurrentMap).name

End Sub

''
' Calcula la orden de Pestañas
'
' @param Map Especifica path del mapa

Public Sub Pestañas(ByVal Map As String)
'*************************************************
'Author: ^[GS]^
'Last modified: 28/05/06
'*************************************************
On Error Resume Next
Dim loopc As Integer

For loopc = Len(Map) To 1 Step -1
    If mid(Map, loopc, 1) = "\" Then
        PATH_Save = Left(Map, loopc)
        Exit For
    End If
Next
Map = Right(Map, Len(Map) - (Len(PATH_Save)))
For loopc = Len(Left(Map, Len(Map) - 4)) To 1 Step -1
    If IsNumeric(mid(Left(Map, Len(Map) - 4), loopc, 1)) = False Then
        NumMap_Save = Right(Left(Map, Len(Map) - 4), Len(Left(Map, Len(Map) - 4)) - loopc)
        NameMap_Save = Left(Map, loopc)
        Exit For
    End If
Next
End Sub




