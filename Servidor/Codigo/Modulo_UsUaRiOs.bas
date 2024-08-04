Attribute VB_Name = "UsUaRiOs"
'AoYind 3.0.0
'Copyright (C) 2002 M�rquez Pablo Ignacio
'
'This program is free software; you can redistribute it and/or modify
'it under the terms of the Affero General Public License;
'either version 1 of the License, or any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the Affero General Public License
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'
'
'You can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'Calle 3 n�mero 983 piso 7 dto A
'La Plata - Pcia, Buenos Aires - Republica Argentina
'C�digo Postal 1900
'Pablo Ignacio M�rquez

Option Explicit

'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                        Modulo Usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'Rutinas de los usuarios
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

Sub ActStats(ByVal VictimIndex As Integer, ByVal attackerIndex As Integer)
    Dim DaExp As Integer
    Dim EraCriminal As Boolean
    
    DaExp = CInt(UserList(VictimIndex).Stats.ELV) * 2
    
    With UserList(attackerIndex)
        .Stats.Exp = .Stats.Exp + DaExp
        If .Stats.Exp > MAXEXP Then .Stats.Exp = MAXEXP
        
        'Lo mata
        Call WriteConsoleMsg(attackerIndex, "Has matado a " & UserList(VictimIndex).Name & "!", FontTypeNames.FONTTYPE_FIGHT)
        Call WriteConsoleMsg(attackerIndex, "Has ganado " & DaExp & " puntos de experiencia.", FontTypeNames.FONTTYPE_EXP)
              
        Call WriteConsoleMsg(VictimIndex, "�" & .Name & " te ha matado!", FontTypeNames.FONTTYPE_FIGHT)
        
        If TriggerZonaPelea(VictimIndex, attackerIndex) <> TRIGGER6_PERMITE Then
            EraCriminal = Criminal(attackerIndex)
            
            With .Reputacion
                If Not Criminal(VictimIndex) Then
                    .AsesinoRep = .AsesinoRep + vlASESINO * 2
                    If .AsesinoRep > MAXREP Then .AsesinoRep = MAXREP
                    .BurguesRep = 0
                    .NobleRep = 0
                    .PlebeRep = 0
                Else
                    .NobleRep = .NobleRep + vlNoble
                    If .NobleRep > MAXREP Then .NobleRep = MAXREP
                End If
            End With
            
            If Criminal(attackerIndex) Then
                If Not EraCriminal Then Call RefreshCharStatus(attackerIndex)
            Else
                If EraCriminal Then Call RefreshCharStatus(attackerIndex)
            End If
        End If
        
        'Call UserDie(VictimIndex)
        
        Call FlushBuffer(VictimIndex)
        
        'Log
        Call LogAsesinato(.Name & " asesino a " & UserList(VictimIndex).Name)
    End With
End Sub

Sub RevivirUsuario(ByVal UserIndex As Integer)
    With UserList(UserIndex)
        .flags.Muerto = 0
        .Stats.MinHP = .Stats.UserAtributos(eAtributos.Constitucion)
        
        If .Stats.MinHP > .Stats.MaxHP Then
            .Stats.MinHP = .Stats.MaxHP
        End If
        
        If .flags.Navegando = 1 Then
            Call ToggleBoatBody(UserIndex)
        Else
            Call DarCuerpoDesnudo(UserIndex)
            
            .Char.Head = .OrigChar.Head
        End If
        
        Call ChangeUserChar(UserIndex, .Char.Body, .Char.Head, .Char.Heading, .Char.WeaponAnim, .Char.ShieldAnim, .Char.CascoAnim)
        Call WriteUpdateUserStats(UserIndex)
    End With
End Sub

Sub ChangeUserChar(ByVal UserIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As Byte, _
                    ByVal Arma As Integer, ByVal Escudo As Integer, ByVal casco As Integer)

    With UserList(UserIndex).Char
        .Body = Body
        .Head = Head
        .Heading = Heading
        .WeaponAnim = Arma
        .ShieldAnim = Escudo
        .CascoAnim = casco
        
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCharacterChange(Body, Head, Heading, .CharIndex, Arma, Escudo, .FX, .Loops, casco))
    End With
End Sub

Sub EnviarFama(ByVal UserIndex As Integer)
    Dim L As Long
    
    With UserList(UserIndex).Reputacion
        L = (-.AsesinoRep) + _
            (-.BandidoRep) + _
            .BurguesRep + _
            (-.LadronesRep) + _
            .NobleRep + _
            .PlebeRep
        L = Round(L / 6)
        
        .Promedio = L
    End With
    
    Call WriteFame(UserIndex)
End Sub

Sub EraseUserChar(ByVal UserIndex As Integer)

On Error GoTo ErrorHandler
    
    With UserList(UserIndex)
        CharList(.Char.CharIndex) = 0
        
        If .Char.CharIndex = LastChar Then
            Do Until CharList(LastChar) > 0
                LastChar = LastChar - 1
                If LastChar <= 1 Then Exit Do
            Loop
        End If
        
        'Le mandamos el mensaje para que borre el personaje a los clientes que est�n cerca
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCharacterRemove(.Char.CharIndex))
        'Call QuitarUser(UserIndex, .Pos.map)
        
        MapData(.Pos.map, .Pos.X, .Pos.Y).UserIndex = 0
        .Char.CharIndex = 0
    End With
    
    NumChars = NumChars - 1
Exit Sub
    
ErrorHandler:
    Call LogError("Error en EraseUserchar " & Err.Number & ": " & Err.Description)
End Sub

Sub RefreshCharStatus(ByVal UserIndex As Integer)
'*************************************************
'Author: Tararira
'Last modified: 04/21/2008 (NicoNZ)
'Refreshes the status and tag of UserIndex.
'*************************************************
    Dim klan As String
    Dim Barco As ObjData
    Dim esCriminal As Boolean
    
    With UserList(UserIndex)
        If .GuildIndex > 0 Then
            klan = modGuilds.GuildName(.GuildIndex)
            klan = " <" & klan & ">"
        End If
        
        esCriminal = Criminal(UserIndex)
        
        If .showName Then
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageUpdateTagAndStatus(UserIndex, esCriminal, .Name & klan))
        Else
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageUpdateTagAndStatus(UserIndex, esCriminal, vbNullString))
        End If
        
        'Si esta navengando, se cambia la barca.
        If .flags.Navegando Then
            Call ToggleBoatBody(UserIndex)
            
            Call ChangeUserChar(UserIndex, .Char.Body, .Char.Head, .Char.Heading, .Char.WeaponAnim, .Char.ShieldAnim, .Char.CascoAnim)
        End If
    End With
End Sub

Sub MakeUserChar(ByVal toMap As Boolean, ByVal sndIndex As Integer, ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer)

On Error GoTo hayerror
    Dim CharIndex As Integer

    If InMapBounds(map, X, Y) Then
        'If needed make a new character in list
        If UserList(UserIndex).Char.CharIndex = 0 Then
            CharIndex = NextOpenCharIndex
            UserList(UserIndex).Char.CharIndex = CharIndex
            CharList(CharIndex) = UserIndex
        End If
        
        'Place character on map if needed
        If toMap Then MapData(map, X, Y).UserIndex = UserIndex
        
        'Send make character command to clients
        Dim klan As String
        If UserList(UserIndex).GuildIndex > 0 Then
            klan = modGuilds.GuildName(UserList(UserIndex).GuildIndex)
        End If
        
        Dim bCr As Byte
        
        bCr = Criminal(UserIndex)
        
        If LenB(klan) <> 0 Then
            If Not toMap Then
                If UserList(UserIndex).showName Then
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, UserList(UserIndex).Name & " <" & klan & ">", bCr, UserList(UserIndex).flags.Privilegios)
                Else
                    'Hide the name and clan - set privs as normal user
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, vbNullString, bCr, PlayerType.user)
                End If
            Else
                Call AgregarUser(UserIndex, UserList(UserIndex).Pos.map)
            End If
        Else 'if tiene clan
            If Not toMap Then
                If UserList(UserIndex).showName Then
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, UserList(UserIndex).Name, bCr, UserList(UserIndex).flags.Privilegios)
                Else
                    Call WriteCharacterCreate(sndIndex, UserList(UserIndex).Char.Body, UserList(UserIndex).Char.Head, UserList(UserIndex).Char.Heading, UserList(UserIndex).Char.CharIndex, X, Y, UserList(UserIndex).Char.WeaponAnim, UserList(UserIndex).Char.ShieldAnim, UserList(UserIndex).Char.FX, 999, UserList(UserIndex).Char.CascoAnim, vbNullString, bCr, PlayerType.user)
                End If
            Else
                Call AgregarUser(UserIndex, UserList(UserIndex).Pos.map)
            End If
        End If 'if clan
    End If
Exit Sub

hayerror:
    LogError ("MakeUserChar: num: " & Err.Number & " desc: " & Err.Description)
    'Resume Next
    Call CloseSocket(UserIndex)
End Sub

''
' Checks if the user gets the next level.
'
' @param UserIndex Specifies reference to user

Sub CheckUserLevel(ByVal UserIndex As Integer)
'*************************************************
'Author: Unknown
'Last modified: 12/09/2007
'Chequea que el usuario no halla alcanzado el siguiente nivel,
'de lo contrario le da la vida, mana, etc, correspodiente.
'07/08/2006 Integer - Modificacion de los valores
'01/10/2007 Tavo - Corregido el BUG de STAT_MAXELV
'24/01/2007 Pablo (ToxicWaste) - Agrego modificaciones en ELU al subir de nivel.
'24/01/2007 Pablo (ToxicWaste) - Agrego modificaciones de la subida de mana de los magos por lvl.
'13/03/2007 Pablo (ToxicWaste) - Agrego diferencias entre el 18 y el 19 en Constituci�n.
'09/01/2008 Pablo (ToxicWaste) - Ahora el incremento de vida por Consituci�n se controla desde Balance.dat
'12/09/2008 Marco Vanotti (Marco) - Ahora si se llega a nivel 25 y est� en un clan, se lo expulsa para no sumar antifacci�n
'02/03/2009 ZaMa - Arreglada la validacion de expulsion para miembros de clanes faccionarios que llegan a 25.
'*************************************************
    Dim Pts As Integer
    Dim AumentoHIT As Integer
    Dim AumentoMANA As Integer
    Dim AumentoSTA As Integer
    Dim AumentoHP As Integer
    Dim WasNewbie As Boolean
    Dim Promedio As Double
    Dim aux As Integer
    Dim DistVida(1 To 5) As Integer
    Dim GI As Integer 'Guild Index
    Dim Ciudad As WorldPos
    
On Error GoTo Errhandler
    
    WasNewbie = EsNewbie(UserIndex)
    
    With UserList(UserIndex)
        Do While .Stats.Exp >= .Stats.ELU
            
            'Checkea si alcanz� el m�ximo nivel
            If .Stats.ELV >= STAT_MAXELV Then
                .Stats.Exp = 0
                .Stats.ELU = 0
                Exit Sub
            End If
            
            'Store it!
            Call Statistics.UserLevelUp(UserIndex)
            
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_NIVEL, .Pos.X, .Pos.Y))
            Call WriteConsoleMsg(UserIndex, "�Has subido de nivel!", FontTypeNames.FONTTYPE_INFO)
            
            If .Stats.ELV = 1 Then
                Pts = 10
            Else
                'For multiple levels being rised at once
                Pts = Pts + 5
            End If
            
            .Stats.ELV = .Stats.ELV + 1
            
            .Stats.Exp = .Stats.Exp - .Stats.ELU
            
            'Nueva subida de exp x lvl. Pablo (ToxicWaste)
            If .Stats.ELV < 15 Then
                .Stats.ELU = .Stats.ELU * 1.4
            ElseIf .Stats.ELV < 25 Then
                .Stats.ELU = .Stats.ELU * 1.3
            ElseIf .Stats.ELV < 35 Then
                .Stats.ELU = .Stats.ELU * 1.35
            ElseIf .Stats.ELV < 40 Then
                .Stats.ELU = .Stats.ELU * 1.4
            ElseIf .Stats.ELV < 41 Then
                .Stats.ELU = .Stats.ELU * 4
            Else
                .Stats.ELU = .Stats.ELU * 1.6
            End If
            
            'Calculo subida de vida
            Promedio = ModVida(.clase) - (21 - .Stats.UserAtributos(eAtributos.Constitucion)) * 0.5
            aux = RandomNumber(0, 100)
            
            If Promedio - Int(Promedio) = 0.5 Then
                'Es promedio semientero
                DistVida(1) = DistribucionSemienteraVida(1)
                DistVida(2) = DistVida(1) + DistribucionSemienteraVida(2)
                DistVida(3) = DistVida(2) + DistribucionSemienteraVida(3)
                DistVida(4) = DistVida(3) + DistribucionSemienteraVida(4)
                
                If aux <= DistVida(1) Then
                    AumentoHP = Promedio + 1.5
                ElseIf aux <= DistVida(2) Then
                    AumentoHP = Promedio + 0.5
                ElseIf aux <= DistVida(3) Then
                    AumentoHP = Promedio - 0.5
                Else
                    AumentoHP = Promedio - 1.5
                End If
            Else
                'Es promedio entero
                DistVida(1) = DistribucionEnteraVida(1)
                DistVida(2) = DistVida(1) + DistribucionEnteraVida(2)
                DistVida(3) = DistVida(2) + DistribucionEnteraVida(3)
                DistVida(4) = DistVida(3) + DistribucionEnteraVida(4)
                DistVida(5) = DistVida(4) + DistribucionEnteraVida(5)
                
                If aux <= DistVida(1) Then
                    AumentoHP = Promedio + 2
                ElseIf aux <= DistVida(2) Then
                    AumentoHP = Promedio + 1
                ElseIf aux <= DistVida(3) Then
                    AumentoHP = Promedio
                ElseIf aux <= DistVida(4) Then
                    AumentoHP = Promedio - 1
                Else
                    AumentoHP = Promedio - 2
                End If
                
            End If
        
            Select Case .clase
                Case eClass.Warrior
                    AumentoHIT = IIf(.Stats.ELV > 35, 2, 3)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Hunter
                    AumentoHIT = IIf(.Stats.ELV > 35, 2, 3)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Pirat
                    AumentoHIT = 3
                    AumentoSTA = AumentoSTDef
                
                Case eClass.PALADIN
                    AumentoHIT = IIf(.Stats.ELV > 35, 1, 3)
                    AumentoMANA = .Stats.UserAtributos(eAtributos.Inteligencia)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Thief
                    AumentoHIT = 1
                    AumentoSTA = AumentoSTLadron
                
                Case eClass.Mage
                    AumentoHIT = 1
                    AumentoMANA = 2.8 * .Stats.UserAtributos(eAtributos.Inteligencia)
                    AumentoSTA = AumentoSTMago
                
                
                Case eClass.Cleric
                    AumentoHIT = 2
                    AumentoMANA = 2 * .Stats.UserAtributos(eAtributos.Inteligencia)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Druid
                    AumentoHIT = 2
                    AumentoMANA = 2 * .Stats.UserAtributos(eAtributos.Inteligencia)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Assasin
                    AumentoHIT = IIf(.Stats.ELV > 35, 1, 3)
                    AumentoMANA = .Stats.UserAtributos(eAtributos.Inteligencia)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Bard
                    AumentoHIT = 2
                    AumentoMANA = 2 * .Stats.UserAtributos(eAtributos.Inteligencia)
                    AumentoSTA = AumentoSTDef
                
                Case eClass.Worker
                    AumentoHIT = 2
                    AumentoSTA = AumentoSTDef
                    
                Case eClass.Bandit
                    AumentoHIT = IIf(.Stats.ELV > 35, 1, 3)
                    AumentoMANA = IIf(.Stats.MaxMAN = 300, 0, .Stats.UserAtributos(eAtributos.Inteligencia) - 10)
                    If AumentoMANA < 4 Then AumentoMANA = 4
                    AumentoSTA = AumentoSTLe�ador
                
                Case Else
                    AumentoHIT = 2
                    AumentoSTA = AumentoSTDef
            End Select
            
            'Actualizamos HitPoints
            .Stats.MaxHP = .Stats.MaxHP + AumentoHP
            If .Stats.MaxHP > STAT_MAXHP Then .Stats.MaxHP = STAT_MAXHP
            
            'Actualizamos Stamina
            .Stats.MaxSta = .Stats.MaxSta + AumentoSTA
            If .Stats.MaxSta > STAT_MAXSTA Then .Stats.MaxSta = STAT_MAXSTA
            
            'Actualizamos Mana
            .Stats.MaxMAN = .Stats.MaxMAN + AumentoMANA
            If .Stats.MaxMAN > STAT_MAXMAN Then .Stats.MaxMAN = STAT_MAXMAN
            
            If .clase = eClass.Bandit Then 'mana del bandido restringido hasta 300
                If .Stats.MaxMAN > 300 Then
                    .Stats.MaxMAN = 300
                End If
            End If
            
            'Actualizamos Golpe M�ximo
            .Stats.MaxHIT = .Stats.MaxHIT + AumentoHIT
            If .Stats.ELV < 36 Then
                If .Stats.MaxHIT > STAT_MAXHIT_UNDER36 Then _
                    .Stats.MaxHIT = STAT_MAXHIT_UNDER36
            Else
                If .Stats.MaxHIT > STAT_MAXHIT_OVER36 Then _
                    .Stats.MaxHIT = STAT_MAXHIT_OVER36
            End If
            
            'Actualizamos Golpe M�nimo
            .Stats.MinHIT = .Stats.MinHIT + AumentoHIT
            If .Stats.ELV < 36 Then
                If .Stats.MinHIT > STAT_MAXHIT_UNDER36 Then _
                    .Stats.MinHIT = STAT_MAXHIT_UNDER36
            Else
                If .Stats.MinHIT > STAT_MAXHIT_OVER36 Then _
                    .Stats.MinHIT = STAT_MAXHIT_OVER36
            End If
            
            'Notificamos al user
            If AumentoHP > 0 Then
                Call WriteConsoleMsg(UserIndex, "Has ganado " & AumentoHP & " puntos de vida.", FontTypeNames.FONTTYPE_INFO)
            End If
            If AumentoSTA > 0 Then
                Call WriteConsoleMsg(UserIndex, "Has ganado " & AumentoSTA & " puntos de vitalidad.", FontTypeNames.FONTTYPE_INFO)
            End If
            If AumentoMANA > 0 Then
                Call WriteConsoleMsg(UserIndex, "Has ganado " & AumentoMANA & " puntos de magia.", FontTypeNames.FONTTYPE_INFO)
            End If
            If AumentoHIT > 0 Then
                Call WriteConsoleMsg(UserIndex, "Tu golpe m�ximo aument� en " & AumentoHIT & " puntos.", FontTypeNames.FONTTYPE_INFO)
                Call WriteConsoleMsg(UserIndex, "Tu golpe minimo aument� en " & AumentoHIT & " puntos.", FontTypeNames.FONTTYPE_INFO)
            End If
            
            Call LogDesarrollo(.Name & " paso a nivel " & .Stats.ELV & " gano HP: " & AumentoHP)
            
            .Stats.MinHP = .Stats.MaxHP

                'If user is in a party, we modify the variable p_sumaniveleselevados
                Call mdParty.ActualizarSumaNivelesElevados(UserIndex)
                    'If user reaches lvl 25 and he is in a guild, we check the guild's alignment and expulses the user if guild has factionary alignment
        
            If .Stats.ELV = 25 Then
                GI = .GuildIndex
                If GI > 0 Then
                    If modGuilds.GuildAlignment(GI) = "Legi�n oscura" Or modGuilds.GuildAlignment(GI) = "Armada Real" Then
                        'We get here, so guild has factionary alignment, we have to expulse the user
                        Call modGuilds.m_EcharMiembroDeClan(-1, .Name)
                        Call SendData(SendTarget.ToGuildMembers, GI, PrepareMessageConsoleMsg(.Name & " deja el clan.", FontTypeNames.FONTTYPE_GUILD))
                        Call WriteConsoleMsg(UserIndex, "�Ya tienes la madurez suficiente como para decidir bajo que estandarte pelear�s! Por esta raz�n, hasta tanto no te enlistes en la Facci�n bajo la cual tu clan est� alineado, estar�s exclu�do del mismo.", FontTypeNames.FONTTYPE_GUILD)
                    End If
                End If
            End If

        Loop
        
        'If it ceased to be a newbie, remove newbie items and get char away from newbie dungeon
        If Not EsNewbie(UserIndex) And WasNewbie Then
            Call QuitarNewbieObj(UserIndex)
            If Zonas(.Zona).Restringir = 13 Then
                Select Case UserList(UserIndex).Hogar
                    Case eCiudad.cNix
                        Ciudad = Nix
                    Case eCiudad.cUllathorpe
                        Ciudad = Ullathorpe
                    Case eCiudad.cBanderbill
                        Ciudad = Banderbill
                    Case eCiudad.cArkhein
                        Ciudad = Arkhein
                    Case eCiudad.cArghal
                        Ciudad = Arghal
                    Case eCiudad.cLindos
                        Ciudad = Lindos
                    Case Else
                        Ciudad = Ullathorpe
                End Select
                Call WarpUserChar(UserIndex, Ciudad.map, Ciudad.X, Ciudad.Y, True)
                Call WriteConsoleMsg(UserIndex, "Debes abandonar el Dungeon Newbie.", FontTypeNames.FONTTYPE_INFO)
            End If
        End If
        
        'Send all gained skill points at once (if any)
        If Pts > 0 Then
            Call WriteLevelUp(UserIndex, Pts)
            
            .Stats.SkillPts = .Stats.SkillPts + Pts
            
            Call WriteConsoleMsg(UserIndex, "Has ganado un total de " & Pts & " skillpoints.", FontTypeNames.FONTTYPE_INFO)
        End If
        
    End With
    
    Call WriteUpdateUserStats(UserIndex)
Exit Sub

Errhandler:
    Call LogError("Error en la subrutina CheckUserLevel - Error : " & Err.Number & " - Description : " & Err.Description)
End Sub

Public Function PuedeAtravesarAgua(ByVal UserIndex As Integer) As Boolean
    PuedeAtravesarAgua = UserList(UserIndex).flags.Navegando = 1 _
                    Or UserList(UserIndex).flags.Vuela = 1
End Function

Sub MoveUserChar(ByVal UserIndex As Integer, ByVal nHeading As eHeading)
'*************************************************
'Author: Unknown
'Last modified: 28/05/2009
'Moves the char, sending the message to everyone in range.
'30/03/2009: ZaMa - Now it's legal to move where a casper is, changing its pos to where the moving char was.
'28/05/2009: ZaMa - When you are moved out of an Arena, the resurrection safe is activated
'*************************************************
    Dim nPos As WorldPos
    Dim sailing As Boolean
    Dim CasperIndex As Integer
    Dim CasperHeading As eHeading
    Dim CasperPos As WorldPos
    
    sailing = PuedeAtravesarAgua(UserIndex)
    nPos = UserList(UserIndex).Pos
    Call HeadtoPos(nHeading, nPos)
        
   If MoveToLegalPos(UserList(UserIndex).Pos.map, nPos.X, nPos.Y, sailing, Not sailing) Then
        'si no estoy solo en el mapa...
        If UserList(UserIndex).AreasInfo.Users.Count > 1 Then
               
            CasperIndex = MapData(UserList(UserIndex).Pos.map, nPos.X, nPos.Y).UserIndex
            'Si hay un usuario, y paso la validacion, entonces es un casper
            If CasperIndex > 0 Then
            
                If TriggerZonaPelea(UserIndex, CasperIndex) = TRIGGER6_PROHIBE Then
                    If UserList(CasperIndex).flags.SeguroResu = False Then
                        UserList(CasperIndex).flags.SeguroResu = True
                        Call WriteResuscitationSafeOn(CasperIndex)
                    End If
                End If

                CasperHeading = InvertHeading(nHeading)
                CasperPos = UserList(CasperIndex).Pos
                Call HeadtoPos(CasperHeading, CasperPos)

                With UserList(CasperIndex)
                    
                    'Call SendData(SendTarget.ToPCAreaButIndex, CasperIndex, PrepareMessageCharacterMove(.Char.CharIndex, CasperPos.X, CasperPos.Y))
                    
                    'Call WriteForceCharMove(CasperIndex, CasperHeading)
                        
                    'Update map and user pos
                    .Pos = CasperPos
                    .Char.Heading = CasperHeading
                    MapData(.Pos.map, CasperPos.X, CasperPos.Y).UserIndex = CasperIndex
                
                End With
            
                'Actualizamos las �reas de ser necesario
                Call ModAreas.CheckUpdateNeededUser(CasperIndex, CasperHeading)
                
            End If

            
            Call SendData(SendTarget.ToPCAreaButIndex, UserIndex, _
                    PrepareMessageCharacterMove(UserList(UserIndex).Char.CharIndex, nPos.X, nPos.Y))
            
        End If
        
        Dim oldUserIndex As Integer
        
        oldUserIndex = MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex
        
        ' Si no hay intercambio de pos con nadie
        If oldUserIndex = UserIndex Then
            MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex = 0
        End If
        
        UserList(UserIndex).Pos = nPos
        UserList(UserIndex).Char.Heading = nHeading
        MapData(UserList(UserIndex).Pos.map, UserList(UserIndex).Pos.X, UserList(UserIndex).Pos.Y).UserIndex = UserIndex
        
        'Actualizamos las �reas de ser necesario
        Call ModAreas.CheckUpdateNeededUser(UserIndex, nHeading)

    Else
        Call WritePosUpdate(UserIndex)
    End If
    
    If UserList(UserIndex).Counters.Trabajando Then _
        UserList(UserIndex).Counters.Trabajando = UserList(UserIndex).Counters.Trabajando - 1

    If UserList(UserIndex).Counters.Ocultando Then _
        UserList(UserIndex).Counters.Ocultando = UserList(UserIndex).Counters.Ocultando - 1
End Sub

Public Function InvertHeading(ByVal nHeading As eHeading) As eHeading
'*************************************************
'Author: ZaMa
'Last modified: 30/03/2009
'Returns the heading opposite to the one passed by val.
'*************************************************
    Select Case nHeading
        Case eHeading.EAST
            InvertHeading = WEST
        Case eHeading.WEST
            InvertHeading = EAST
        Case eHeading.SOUTH
            InvertHeading = NORTH
        Case eHeading.NORTH
            InvertHeading = SOUTH
    End Select
End Function
Public Function HasEnoughItems(ByVal UserIndex As Integer, ByVal ObjIndex As Integer, ByVal Amount As Long) As Boolean
'**************************************************************
'Author: ZaMa
'Last Modify Date: 25/11/2009
'Cheks Wether the user has the required amount of items in the inventory or not
'**************************************************************

    Dim Slot As Long
    Dim ItemInvAmount As Long
    
    For Slot = 1 To UserList(UserIndex).CurrentInventorySlots
        ' Si es el item que busco
        If UserList(UserIndex).Invent.Object(Slot).ObjIndex = ObjIndex Then
            ' Lo sumo a la cantidad total
            ItemInvAmount = ItemInvAmount + UserList(UserIndex).Invent.Object(Slot).Amount
        End If
    Next Slot

    HasEnoughItems = Amount <= ItemInvAmount
End Function
Public Function TotalOfferItems(ByVal ObjIndex As Integer, ByVal UserIndex As Integer) As Long
'**************************************************************
'Author: ZaMa
'Last Modify Date: 25/11/2009
'Cheks the amount of items the user has in offerSlots.
'**************************************************************
    Dim Slot As Byte
    
    For Slot = 1 To MAX_OFFER_SLOTS
            ' Si es el item que busco
        If UserList(UserIndex).ComUsu.Objeto(Slot) = ObjIndex Then
            ' Lo sumo a la cantidad total
            TotalOfferItems = TotalOfferItems + UserList(UserIndex).ComUsu.Cant(Slot)
        End If
    Next Slot

End Function

Sub ChangeUserInv(ByVal UserIndex As Integer, ByVal Slot As Byte, ByRef Object As UserOBJ)
    UserList(UserIndex).Invent.Object(Slot) = Object
    Call WriteChangeInventorySlot(UserIndex, Slot)
End Sub

Function NextOpenCharIndex() As Integer
    Dim LoopC As Long
    
    For LoopC = 1 To MAXCHARS
        If CharList(LoopC) = 0 Then
            NextOpenCharIndex = LoopC
            NumChars = NumChars + 1
            
            If LoopC > LastChar Then _
                LastChar = LoopC
            
            Exit Function
        End If
    Next LoopC
End Function

Function NextOpenUser() As Integer
    Dim LoopC As Long
    
    For LoopC = 1 To MaxUsers + 1
        If LoopC > MaxUsers Then Exit For
        If (UserList(LoopC).ConnID = -1 And UserList(LoopC).flags.UserLogged = False) Then Exit For
    Next LoopC
    
    NextOpenUser = LoopC
End Function

Public Sub SendUserStatsTxt(ByVal sendIndex As Integer, ByVal UserIndex As Integer)
    Dim GuildI As Integer
    
    With UserList(UserIndex)
        Call WriteConsoleMsg(sendIndex, "Estadisticas de: " & .Name, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Nivel: " & .Stats.ELV & "  EXP: " & .Stats.Exp & "/" & .Stats.ELU, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Salud: " & .Stats.MinHP & "/" & .Stats.MaxHP & "  Mana: " & .Stats.MinMAN & "/" & .Stats.MaxMAN & "  Vitalidad: " & .Stats.MinSta & "/" & .Stats.MaxSta, FontTypeNames.FONTTYPE_INFO)
        
        If .Invent.WeaponEqpObjIndex > 0 Then
            Call WriteConsoleMsg(sendIndex, "Menor Golpe/Mayor Golpe: " & .Stats.MinHIT & "/" & .Stats.MaxHIT & " (" & ObjData(.Invent.WeaponEqpObjIndex).MinHIT & "/" & ObjData(.Invent.WeaponEqpObjIndex).MaxHIT & ")", FontTypeNames.FONTTYPE_INFO)
        Else
            Call WriteConsoleMsg(sendIndex, "Menor Golpe/Mayor Golpe: " & .Stats.MinHIT & "/" & .Stats.MaxHIT, FontTypeNames.FONTTYPE_INFO)
        End If
        
        If .Invent.ArmourEqpObjIndex > 0 Then
            If .Invent.EscudoEqpObjIndex > 0 Then
                Call WriteConsoleMsg(sendIndex, "(CUERPO) Min Def/Max Def: " & ObjData(.Invent.ArmourEqpObjIndex).MinDef + ObjData(.Invent.EscudoEqpObjIndex).MinDef & "/" & ObjData(.Invent.ArmourEqpObjIndex).MaxDef + ObjData(.Invent.EscudoEqpObjIndex).MaxDef, FontTypeNames.FONTTYPE_INFO)
            Else
                Call WriteConsoleMsg(sendIndex, "(CUERPO) Min Def/Max Def: " & ObjData(.Invent.ArmourEqpObjIndex).MinDef & "/" & ObjData(.Invent.ArmourEqpObjIndex).MaxDef, FontTypeNames.FONTTYPE_INFO)
            End If
        Else
            Call WriteConsoleMsg(sendIndex, "(CUERPO) Min Def/Max Def: 0", FontTypeNames.FONTTYPE_INFO)
        End If
        
        If .Invent.CascoEqpObjIndex > 0 Then
            Call WriteConsoleMsg(sendIndex, "(CABEZA) Min Def/Max Def: " & ObjData(.Invent.CascoEqpObjIndex).MinDef & "/" & ObjData(.Invent.CascoEqpObjIndex).MaxDef, FontTypeNames.FONTTYPE_INFO)
        Else
            Call WriteConsoleMsg(sendIndex, "(CABEZA) Min Def/Max Def: 0", FontTypeNames.FONTTYPE_INFO)
        End If
        
        GuildI = .GuildIndex
        If GuildI > 0 Then
            Call WriteConsoleMsg(sendIndex, "Clan: " & modGuilds.GuildName(GuildI), FontTypeNames.FONTTYPE_INFO)
            If UCase$(modGuilds.GuildLeader(GuildI)) = UCase$(.Name) Then
                Call WriteConsoleMsg(sendIndex, "Status: Lider", FontTypeNames.FONTTYPE_INFO)
            End If
            'guildpts no tienen objeto
        End If
        
#If ConUpTime Then
        Dim TempDate As Date
        Dim TempSecs As Long
        Dim TempStr As String
        TempDate = Now - .LogOnTime
        TempSecs = (.UpTime + (Abs(Day(TempDate) - 30) * 24 * 3600) + (Hour(TempDate) * 3600) + (Minute(TempDate) * 60) + Second(TempDate))
        TempStr = (TempSecs \ 86400) & " Dias, " & ((TempSecs Mod 86400) \ 3600) & " Horas, " & ((TempSecs Mod 86400) Mod 3600) \ 60 & " Minutos, " & (((TempSecs Mod 86400) Mod 3600) Mod 60) & " Segundos."
        Call WriteConsoleMsg(sendIndex, "Logeado hace: " & Hour(TempDate) & ":" & Minute(TempDate) & ":" & Second(TempDate), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Total: " & TempStr, FontTypeNames.FONTTYPE_INFO)
#End If

        If .flags.Traveling = 1 Then
            Call WriteConsoleMsg(sendIndex, "Tiempo restante para llegar a tu hogar: " & GetHomeArrivalTime(UserIndex) & " segundos.", FontTypeNames.FONTTYPE_INFO)
        End If
        
        Call WriteConsoleMsg(sendIndex, "Oro: " & .Stats.GLD & "  Posicion: " & .Pos.X & "," & .Pos.Y & " en mapa " & .Pos.map, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Dados: " & .Stats.UserAtributos(eAtributos.Fuerza) & ", " & .Stats.UserAtributos(eAtributos.Agilidad) & ", " & .Stats.UserAtributos(eAtributos.Inteligencia) & ", " & .Stats.UserAtributos(eAtributos.Carisma) & ", " & .Stats.UserAtributos(eAtributos.Constitucion), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Clase: " & ListaClases(.clase), FontTypeNames.FONTTYPE_INFO)

    
    End With
End Sub

Sub SendUserMiniStatsTxt(ByVal sendIndex As Integer, ByVal UserIndex As Integer)
'*************************************************
'Author: Unknown
'Last modified: 23/01/2007
'Shows the users Stats when the user is online.
'23/01/2007 Pablo (ToxicWaste) - Agrego de funciones y mejora de distribuci�n de par�metros.
'*************************************************
    With UserList(UserIndex)
        Call WriteConsoleMsg(sendIndex, "Pj: " & .Name, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "CiudadanosMatados: " & .Faccion.CiudadanosMatados & " CriminalesMatados: " & .Faccion.CriminalesMatados & " UsuariosMatados: " & .Stats.UsuariosMatados, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "NPCsMuertos: " & .Stats.NPCsMuertos, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Clase: " & ListaClases(.clase), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Pena: " & .Counters.Pena, FontTypeNames.FONTTYPE_INFO)
        
        If .Faccion.ArmadaReal = 1 Then
            Call WriteConsoleMsg(sendIndex, "Armada Real Desde: " & .Faccion.FechaIngreso, FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Ingres� en Nivel: " & .Faccion.NivelIngreso & " con " & .Faccion.MatadosIngreso & " Ciudadanos matados.", FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & .Faccion.Reenlistadas, FontTypeNames.FONTTYPE_INFO)
        
        ElseIf .Faccion.FuerzasCaos = 1 Then
            Call WriteConsoleMsg(sendIndex, "Legion Oscura Desde: " & .Faccion.FechaIngreso, FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Ingres� en Nivel: " & .Faccion.NivelIngreso, FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & .Faccion.Reenlistadas, FontTypeNames.FONTTYPE_INFO)
        
        ElseIf .Faccion.RecibioExpInicialReal = 1 Then
            Call WriteConsoleMsg(sendIndex, "Fue Armada Real", FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & .Faccion.Reenlistadas, FontTypeNames.FONTTYPE_INFO)
        
        ElseIf .Faccion.RecibioExpInicialCaos = 1 Then
            Call WriteConsoleMsg(sendIndex, "Fue Legionario", FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & .Faccion.Reenlistadas, FontTypeNames.FONTTYPE_INFO)
        End If
        
        Call WriteConsoleMsg(sendIndex, "Asesino: " & .Reputacion.AsesinoRep, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Noble: " & .Reputacion.NobleRep, FontTypeNames.FONTTYPE_INFO)
        
        If .GuildIndex > 0 Then
            Call WriteConsoleMsg(sendIndex, "Clan: " & GuildName(.GuildIndex), FontTypeNames.FONTTYPE_INFO)
        End If
    End With
End Sub

Sub SendUserMiniStatsTxtFromChar(ByVal sendIndex As Integer, ByVal charName As String)
'*************************************************
'Author: Unknown
'Last modified: 23/01/2007
'Shows the users Stats when the user is offline.
'23/01/2007 Pablo (ToxicWaste) - Agrego de funciones y mejora de distribuci�n de par�metros.
'*************************************************
    Dim Ban As String
    Dim BanDetailPath As String
    
    BanDetailPath = App.Path & "\logs\" & "BanDetail.dat"
    
    Dim Datos As clsMySQLRecordSet
    Dim Cant As Long
    Cant = mySQL.SQLQuery("SELECT CiudMatados,NpcsMuertes,Clase,Pena,EjercitoReal,EjercitoCaos,FechaIngreso,NivelIngreso,MatadosIngreso,Reenlistadas,rExReal,rExCaos,Rep_Asesino,Rep_Noble,GuildIndex,Ban,BannedBy FROM pjs WHERE Nombre=" & Comillas(charName), Datos)
    
    
    If Cant > 0 Then
        Call WriteConsoleMsg(sendIndex, "Pj: " & charName, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "CiudadanosMatados: " & Datos("CiudMatados") & " CriminalesMatados: " & Datos("CrimMatados") & " UsuariosMatados: " & Datos("UserMuertes"), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "NPCsMuertos: " & Datos("NpcsMuertes"), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Clase: " & ListaClases(Datos("Clase")), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Pena: " & Datos("Pena"), FontTypeNames.FONTTYPE_INFO)
        
        If CByte(Datos("EjercitoReal")) = 1 Then
            Call WriteConsoleMsg(sendIndex, "Armada Real Desde: " & Datos("FechaIngreso"), FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Ingres� en Nivel: " & CInt(Datos("NivelIngreso")) & " con " & CInt(Datos("MatadosIngreso")) & " Ciudadanos matados.", FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & CByte(Datos("Reenlistadas")), FontTypeNames.FONTTYPE_INFO)
        
        ElseIf CByte(Datos("EjercitoCaos")) = 1 Then
            Call WriteConsoleMsg(sendIndex, "Legion Oscura Desde: " & Datos("FechaIngreso"), FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Ingres� en Nivel: " & Datos("NivelIngreso"), FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & Datos("Reenlistadas"), FontTypeNames.FONTTYPE_INFO)
        
        ElseIf CByte(Datos("rExReal")) = 1 Then
            Call WriteConsoleMsg(sendIndex, "Fue Armada Real", FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & CByte(Datos("Reenlistadas")), FontTypeNames.FONTTYPE_INFO)
        
        ElseIf CByte(Datos("rExCaos")) = 1 Then
            Call WriteConsoleMsg(sendIndex, "Fue Legionario", FontTypeNames.FONTTYPE_INFO)
            Call WriteConsoleMsg(sendIndex, "Veces que Ingres�: " & CByte(Datos("Reenlistadas")), FontTypeNames.FONTTYPE_INFO)
        End If

        
        Call WriteConsoleMsg(sendIndex, "Asesino: " & CLng(Datos("Rep_Asesino")), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Noble: " & CLng(Datos("Rep_Nobles")), FontTypeNames.FONTTYPE_INFO)
        
        If Datos("GuildIndex") > 0 Then
            Call WriteConsoleMsg(sendIndex, "Clan: " & modGuilds.GuildName(CInt(Datos("GuildIndex"))), FontTypeNames.FONTTYPE_INFO)
        End If
        
        Ban = Datos("Ban")
        Call WriteConsoleMsg(sendIndex, "Ban: " & Ban, FontTypeNames.FONTTYPE_INFO)
        
        If Ban = "1" Then
            Call WriteConsoleMsg(sendIndex, "Ban por: " & Datos("BannedBy") & " Motivo: " & GetVar(BanDetailPath, charName, "Reason"), FontTypeNames.FONTTYPE_INFO)
        End If
    Else
        Call WriteConsoleMsg(sendIndex, "El pj no existe: " & charName, FontTypeNames.FONTTYPE_INFO)
    End If
End Sub

Sub SendUserInvTxt(ByVal sendIndex As Integer, ByVal UserIndex As Integer)
On Error Resume Next

    Dim j As Long
    
    With UserList(UserIndex)
        Call WriteConsoleMsg(sendIndex, .Name, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Tiene " & .Invent.NroItems & " objetos.", FontTypeNames.FONTTYPE_INFO)
        
        For j = 1 To MAX_INVENTORY_SLOTS
            If .Invent.Object(j).ObjIndex > 0 Then
                Call WriteConsoleMsg(sendIndex, " Objeto " & j & " " & ObjData(.Invent.Object(j).ObjIndex).Name & " Cantidad:" & .Invent.Object(j).Amount, FontTypeNames.FONTTYPE_INFO)
            End If
        Next j
    End With
End Sub

Sub SendUserInvTxtFromChar(ByVal sendIndex As Integer, ByVal charName As String)
On Error Resume Next

    Dim j As Long
    Dim CharFile As String
    Dim ObjInd As Long, ObjCant As Long
    
    Dim Datos As clsMySQLRecordSet
    Dim Query As String
    Dim Cant As Long
    
    Query = "SELECT InvCantidadItems"
    
    For j = 1 To MAX_INVENTORY_SLOTS
        Query = Query & ", InvObj" & j & ", InvCant" & j
    Next j
    
    Query = Query & " FROM pjs WHERE Nombre=" & Comillas(charName)
    
    Cant = mySQL.SQLQuery(Query, Datos)
    
    If Cant > 0 Then
        
        
        
        Call WriteConsoleMsg(sendIndex, charName, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, " Tiene " & Datos("InvCantidadItems") & " objetos.", FontTypeNames.FONTTYPE_INFO)
        
        For j = 1 To MAX_INVENTORY_SLOTS
            ObjInd = Datos("InvObj" & j)
            ObjCant = Datos("InvCant" & j)
            If ObjInd > 0 Then
                Call WriteConsoleMsg(sendIndex, " Objeto " & j & " " & ObjData(ObjInd).Name & " Cantidad:" & ObjCant, FontTypeNames.FONTTYPE_INFO)
            End If
        Next j
    Else
        Call WriteConsoleMsg(sendIndex, "Usuario inexistente: " & charName, FontTypeNames.FONTTYPE_INFO)
    End If
End Sub

Sub SendUserSkillsTxt(ByVal sendIndex As Integer, ByVal UserIndex As Integer)
On Error Resume Next
    Dim j As Integer
    
    Call WriteConsoleMsg(sendIndex, UserList(UserIndex).Name, FontTypeNames.FONTTYPE_INFO)
    
    For j = 1 To NUMSKILLS
        Call WriteConsoleMsg(sendIndex, SkillsNames(j) & " = " & UserList(UserIndex).Stats.UserSkills(j), FontTypeNames.FONTTYPE_INFO)
    Next j
    
    Call WriteConsoleMsg(sendIndex, " SkillLibres:" & UserList(UserIndex).Stats.SkillPts, FontTypeNames.FONTTYPE_INFO)
End Sub

Private Function EsMascotaCiudadano(ByVal NpcIndex As Integer, ByVal UserIndex As Integer) As Boolean

    If Npclist(NpcIndex).MaestroUser > 0 Then
        EsMascotaCiudadano = Not Criminal(Npclist(NpcIndex).MaestroUser)
        If EsMascotaCiudadano Then
            Call WriteConsoleMsg(Npclist(NpcIndex).MaestroUser, "��" & UserList(UserIndex).Name & " esta atacando tu mascota!!", FontTypeNames.FONTTYPE_INFO)
        End If
    End If
End Function

Sub NPCAtacado(ByVal NpcIndex As Integer, ByVal UserIndex As Integer)
'**********************************************
'Author: Unknown
'Last Modification: 06/28/2008
'24/01/2007 -> Pablo (ToxicWaste): Agrego para que se actualize el tag si corresponde.
'24/07/2007 -> Pablo (ToxicWaste): Guardar primero que ataca NPC y el que atacas ahora.
'06/28/2008 -> NicoNZ: Los elementales al atacarlos por su amo no se paran m�s al lado de �l sin hacer nada.
'**********************************************
    Dim EraCriminal As Boolean
    
    'Guardamos el usuario que ataco el npc.
    Npclist(NpcIndex).flags.AttackedBy = UserList(UserIndex).Name
    
    If Npclist(NpcIndex).NPCtype = Mercader Then
        Call MercaderAtacado(NpcIndex, UserIndex)
    End If
    
    'Npc que estabas atacando.
    Dim LastNpcHit As Integer
    LastNpcHit = UserList(UserIndex).flags.NPCAtacado
    'Guarda el NPC que estas atacando ahora.
    UserList(UserIndex).flags.NPCAtacado = NpcIndex
    
    'Revisamos robo de npc.
    'Guarda el primer nick que lo ataca.
    If Npclist(NpcIndex).flags.AttackedFirstBy = vbNullString Then
        'El que le pegabas antes ya no es tuyo
        If LastNpcHit <> 0 Then
            If Npclist(LastNpcHit).flags.AttackedFirstBy = UserList(UserIndex).Name Then
                Npclist(LastNpcHit).flags.AttackedFirstBy = vbNullString
            End If
        End If
        Npclist(NpcIndex).flags.AttackedFirstBy = UserList(UserIndex).Name
    ElseIf Npclist(NpcIndex).flags.AttackedFirstBy <> UserList(UserIndex).Name Then
        'Estas robando NPC
        'El que le pegabas antes ya no es tuyo
        If LastNpcHit <> 0 Then
            If Npclist(LastNpcHit).flags.AttackedFirstBy = UserList(UserIndex).Name Then
                Npclist(LastNpcHit).flags.AttackedFirstBy = vbNullString
            End If
        End If
    End If
    
    If Npclist(NpcIndex).MaestroUser > 0 Then
        If Npclist(NpcIndex).MaestroUser <> UserIndex Then
            Call AllMascotasAtacanUser(UserIndex, Npclist(NpcIndex).MaestroUser)
        End If
    End If
    
    If EsMascotaCiudadano(NpcIndex, UserIndex) Then
        Call VolverCriminal(UserIndex)
        Npclist(NpcIndex).Movement = TipoAI.NPCDEFENSA
        Npclist(NpcIndex).Hostile = 1
    Else
        EraCriminal = Criminal(UserIndex)
        
        'Reputacion
        If EsGuardiaReal(NpcIndex) Or EsGuardiaNeutral(NpcIndex) Or EsMercader(NpcIndex, True) Then
             Call VolverCriminal(UserIndex)
        ElseIf Npclist(NpcIndex).Stats.Alineacion = 0 Then
                If Not Npclist(NpcIndex).MaestroUser > 0 Then   'mascotas nooo!
                    Call VolverCriminal(UserIndex)
                End If
        ElseIf Npclist(NpcIndex).Stats.Alineacion = 1 Then
           UserList(UserIndex).Reputacion.PlebeRep = UserList(UserIndex).Reputacion.PlebeRep + vlCAZADOR / 2
           If UserList(UserIndex).Reputacion.PlebeRep > MAXREP Then _
            UserList(UserIndex).Reputacion.PlebeRep = MAXREP
        End If
        
        If Npclist(NpcIndex).MaestroUser <> UserIndex Then
            'hacemos que el npc se defienda
            If Npclist(NpcIndex).Movement <> TipoAI.NpcPathfinding And Npclist(NpcIndex).Movement <> TipoAI.Personalizado Then
                Npclist(NpcIndex).Movement = TipoAI.NPCDEFENSA
                Npclist(NpcIndex).Hostile = 1
            End If
        End If
        
        If EraCriminal And Not Criminal(UserIndex) Then
            Call VolverCiudadano(UserIndex)
        End If
    End If
End Sub

Public Function PuedeApu�alar(ByVal UserIndex As Integer) As Boolean

    If UserList(UserIndex).Invent.WeaponEqpObjIndex > 0 Then
        If ObjData(UserList(UserIndex).Invent.WeaponEqpObjIndex).Apu�ala = 1 Then
            PuedeApu�alar = UserList(UserIndex).Stats.UserSkills(eSkill.Apu�alar) >= MIN_APU�ALAR _
                        Or UserList(UserIndex).clase = eClass.Assasin
        End If
    End If
End Function

Sub SubirSkill(ByVal UserIndex As Integer, ByVal Skill As Integer)

    With UserList(UserIndex)
        If .flags.Hambre = 0 And .flags.Sed = 0 Then
            
            If .Stats.UserSkills(Skill) = MAXSKILLPOINTS Then Exit Sub
            
            Dim Lvl As Integer
            Lvl = .Stats.ELV
            
            If Lvl > UBound(LevelSkill) Then Lvl = UBound(LevelSkill)
            
            If .Stats.UserSkills(Skill) >= LevelSkill(Lvl).LevelValue Then Exit Sub
            
            Dim Prob As Integer
            
            If Lvl <= 3 Then
                Prob = 10
            ElseIf Lvl > 3 And Lvl < 6 Then
                Prob = 12
            ElseIf Lvl >= 6 And Lvl < 10 Then
                Prob = 13
            ElseIf Lvl >= 10 And Lvl < 20 Then
                Prob = 14
            Else
                Prob = 15
            End If
            
            
            If RandomNumber(1, Prob) <= 3 Then
                .Stats.UserSkills(Skill) = .Stats.UserSkills(Skill) + 1
                Call WriteConsoleMsg(UserIndex, "�Has mejorado tu skill " & SkillsNames(Skill) & " en un punto!. Ahora tienes " & .Stats.UserSkills(Skill) & " pts.", FontTypeNames.FONTTYPE_INFO)
                
                .Stats.Exp = .Stats.Exp + 100
                If .Stats.Exp > MAXEXP Then .Stats.Exp = MAXEXP
                
                Call WriteConsoleMsg(UserIndex, "�Has ganado 100 puntos de experiencia!", FontTypeNames.FONTTYPE_EXP)
                
                Call WriteUpdateExp(UserIndex)
                Call CheckUserLevel(UserIndex)
            End If
        End If
    End With
End Sub

''
' Muere un usuario
'
' @param UserIndex  Indice del usuario que muere
'

Sub UserDie(ByVal UserIndex As Integer)
'************************************************
'Author: Uknown
'Last Modified: 27/05/2009
'04/15/2008: NicoNZ - Ahora se resetea el counter del invi
'13/02/2009: ZaMa - Ahora se borran las mascotas cuando moris en agua.
'27/05/2009: ZaMa - El seguro de resu no se activa si estas en una arena
'************************************************
On Error GoTo ErrorHandler
    Dim i As Long
    Dim aN As Integer
    
    With UserList(UserIndex)
        'Sonido
        
        If .flags.Muerto = 1 Then Exit Sub
        
        If .genero = eGenero.Mujer Then
            Call ReproducirSonido(SendTarget.ToPCArea, UserIndex, e_SoundIndex.MUERTE_MUJER)
        Else
            Call ReproducirSonido(SendTarget.ToPCArea, UserIndex, e_SoundIndex.MUERTE_HOMBRE)
        End If
        
        'Quitar el dialogo del user muerto
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageRemoveCharDialog(.Char.CharIndex))
        
        .Stats.MinHP = 0
        .Stats.MinSta = 0
        .flags.AtacadoPorUser = 0
        .flags.Envenenado = 0
        .flags.Muerto = 1
        ' No se activa en arenas
        If TriggerZonaPelea(UserIndex, UserIndex) <> TRIGGER6_PERMITE Then
            .flags.SeguroResu = True
            Call WriteResuscitationSafeOn(UserIndex)
        Else
            .flags.SeguroResu = False
            Call WriteResuscitationSafeOff(UserIndex)
        End If
        
        aN = .flags.AtacadoPorNpc
        If aN > 0 Then
            Npclist(aN).Movement = Npclist(aN).flags.OldMovement
            Npclist(aN).Hostile = Npclist(aN).flags.OldHostil
            Npclist(aN).flags.AttackedBy = vbNullString
        End If
        
        aN = .flags.NPCAtacado
        If aN > 0 Then
            If Npclist(aN).flags.AttackedFirstBy = .Name Then
                Npclist(aN).flags.AttackedFirstBy = vbNullString
            End If
        End If
        .flags.AtacadoPorNpc = 0
        .flags.NPCAtacado = 0
        
        '<<<< Paralisis >>>>
        If .flags.Paralizado = 1 Then
            .flags.Paralizado = 0
            Call WriteParalizeOK(UserIndex)
        End If
        
        '<<< Estupidez >>>
        If .flags.Estupidez = 1 Then
            .flags.Estupidez = 0
            Call WriteDumbNoMore(UserIndex)
        End If
        
        '<<<< Descansando >>>>
        If .flags.Descansar Then
            .flags.Descansar = False
            Call WriteRestOK(UserIndex)
        End If
        
        '<<<< Meditando >>>>
        If .flags.Meditando Then
            .flags.Meditando = False
            Call WriteMeditateToggle(UserIndex)
        End If
        
        '<<<< Invisible >>>>
        If .flags.invisible = 1 Or .flags.Oculto = 1 Then
            .flags.Oculto = 0
            .flags.invisible = 0
            .Counters.TiempoOculto = 0
            .Counters.Invisibilidad = 0
            
            'Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(.Char.CharIndex, False))
            Call UsUaRiOs.SetInvisible(UserIndex, UserList(UserIndex).Char.CharIndex, False)
        End If
        
        If TriggerZonaPelea(UserIndex, UserIndex) <> eTrigger6.TRIGGER6_PERMITE And UserList(UserIndex).Zona <> 33 And UserList(UserIndex).Zona <> 34 And UserList(UserIndex).Zona <> 35 Then
            ' << Si es newbie no pierde el inventario >>
            If Not EsNewbie(UserIndex) Then
                Call TirarTodo(UserIndex)
            Else
                Call TirarTodosLosItemsNoNewbies(UserIndex)
            End If
        End If
        
        ' DESEQUIPA TODOS LOS OBJETOS
        'desequipar armadura
        If .Invent.ArmourEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, .Invent.ArmourEqpSlot, False)
        End If
        
        'desequipar arma
        If .Invent.WeaponEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, .Invent.WeaponEqpSlot, False)
        End If
        
        'desequipar casco
        If .Invent.CascoEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, .Invent.CascoEqpSlot, False)
        End If
        
        'desequipar herramienta
        If .Invent.AnilloEqpSlot > 0 Then
            Call Desequipar(UserIndex, .Invent.AnilloEqpSlot, False)
        End If
        
        'desequipar municiones
        If .Invent.MunicionEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, .Invent.MunicionEqpSlot, False)
        End If
        
        'desequipar escudo
        If .Invent.EscudoEqpObjIndex > 0 Then
            Call Desequipar(UserIndex, .Invent.EscudoEqpSlot, False)
        End If
        
        ' << Reseteamos los posibles FX sobre el personaje >>
        If .Char.Loops = INFINITE_LOOPS Then
            .Char.FX = 0
            .Char.Loops = 0
        End If
        
        ' << Restauramos el mimetismo
        If .flags.Mimetizado = 1 Then
            .Char.Body = .CharMimetizado.Body
            .Char.Head = .CharMimetizado.Head
            .Char.CascoAnim = .CharMimetizado.CascoAnim
            .Char.ShieldAnim = .CharMimetizado.ShieldAnim
            .Char.WeaponAnim = .CharMimetizado.WeaponAnim
            .Counters.Mimetismo = 0
            .flags.Mimetizado = 0
        End If
        
        ' << Restauramos los atributos >>
        If .flags.TomoPocion = True Then
            For i = 1 To 5
                .Stats.UserAtributos(i) = .Stats.UserAtributosBackUP(i)
            Next i
        End If
        
        '<< Cambiamos la apariencia del char >>
        If .flags.Navegando = 0 Then
            If .Reputacion.Promedio < 0 Then
                .Char.Body = iCuerpoMuertoCrimi
                .Char.Head = iCabezaMuertoCrimi
            Else
                .Char.Body = iCuerpoMuerto
                .Char.Head = iCabezaMuerto
            End If
            .Char.ShieldAnim = NingunEscudo
            .Char.WeaponAnim = NingunArma
            .Char.CascoAnim = NingunCasco
        Else
            .Char.Body = iFragataFantasmal
        End If
        
        For i = 1 To MAXMASCOTAS
            If .MascotasIndex(i) > 0 Then
                Call MuereNpc(.MascotasIndex(i), 0)
            ' Si estan en agua o zona segura
            Else
                .MascotasType(i) = 0
            End If
        Next i
        
        .NroMascotas = 0
        
        '<< Actualizamos clientes >>
        Call ChangeUserChar(UserIndex, .Char.Body, .Char.Head, .Char.Heading, NingunArma, NingunEscudo, NingunCasco)
        Call WriteUpdateUserStats(UserIndex)
        
        '<<Castigos por party>>
        If .PartyIndex > 0 Then
            Call mdParty.ObtenerExito(UserIndex, .Stats.ELV * -10 * mdParty.CantMiembros(UserIndex), .Pos.map, .Pos.X, .Pos.Y)
        End If
        
        If .SalaIndex > 0 Then
            Call MuereEnSala(UserIndex)
        End If
        
        Call QuitarAgresorMercader(UserIndex)
        
    End With
Exit Sub

ErrorHandler:
    Call LogError("Error en SUB USERDIE. Error: " & Err.Number & " Descripci�n: " & Err.Description)
End Sub

Sub ContarMuerte(ByVal Muerto As Integer, ByVal Atacante As Integer)

    If EsNewbie(Muerto) Then Exit Sub
    
    With UserList(Atacante)
        If TriggerZonaPelea(Muerto, Atacante) = TRIGGER6_PERMITE Then Exit Sub
        
        If Criminal(Muerto) Then
            If .flags.LastCrimMatado <> UserList(Muerto).Name Then
                .flags.LastCrimMatado = UserList(Muerto).Name
                If .Faccion.CriminalesMatados < MAXUSERMATADOS Then _
                    .Faccion.CriminalesMatados = .Faccion.CriminalesMatados + 1
            End If
            
            If .Faccion.RecibioExpInicialCaos = 1 And UserList(Muerto).Faccion.FuerzasCaos = 1 Then
                .Faccion.Reenlistadas = 200  'jaja que trucho
                
                'con esto evitamos que se vuelva a reenlistar
            End If
        Else
            If .flags.LastCiudMatado <> UserList(Muerto).Name Then
                .flags.LastCiudMatado = UserList(Muerto).Name
                If .Faccion.CiudadanosMatados < MAXUSERMATADOS Then _
                    .Faccion.CiudadanosMatados = .Faccion.CiudadanosMatados + 1
            End If
        End If
        
        If .Stats.UsuariosMatados < MAXUSERMATADOS Then _
            .Stats.UsuariosMatados = .Stats.UsuariosMatados + 1
    End With
End Sub

Sub Tilelibre(ByRef Pos As WorldPos, ByRef nPos As WorldPos, ByRef Obj As Obj, ByRef Agua As Boolean, ByRef Tierra As Boolean)
'**************************************************************
'Author: Unknown
'Last Modify Date: 23/01/2007
'23/01/2007 -> Pablo (ToxicWaste): El agua es ahora un TileLibre agregando las condiciones necesarias.
'**************************************************************
    Dim LoopC As Integer
    Dim tX As Long
    Dim tY As Long
    Dim hayobj As Boolean
    
    hayobj = False
    nPos.map = Pos.map
    nPos.X = 0
    nPos.Y = 0
    
    Do While Not LegalPos(Pos.map, nPos.X, nPos.Y, IIf(LoopC < 3, False, True), Tierra) Or hayobj
        
        If LoopC > 10 Then
            Exit Do
        End If
        
        For tY = Pos.Y - LoopC To Pos.Y + LoopC
            For tX = Pos.X - LoopC To Pos.X + LoopC
                
                If LegalPos(nPos.map, tX, tY, IIf(LoopC < 3, False, True), Tierra) Then
                    'We continue if: a - the item is different from 0 and the dropped item or b - the amount dropped + amount in map exceeds MAX_INVENTORY_OBJS
                    hayobj = (MapData(nPos.map, tX, tY).ObjInfo.ObjIndex > 0 And MapData(nPos.map, tX, tY).ObjInfo.ObjIndex <> Obj.ObjIndex)
                    If Not hayobj Then _
                        hayobj = (MapData(nPos.map, tX, tY).ObjInfo.Amount + Obj.Amount > MAX_INVENTORY_OBJS)
                    If Not hayobj And MapData(nPos.map, tX, tY).TileExit.map = 0 Then
                        nPos.X = tX
                        nPos.Y = tY
                        
                        'break both fors
                        tX = Pos.X + LoopC
                        tY = Pos.Y + LoopC
                    End If
                End If
            
            Next tX
        Next tY
        
        LoopC = LoopC + 1
    Loop
End Sub

Sub WarpUserChar(ByVal UserIndex As Integer, ByVal map As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal FX As Boolean, Optional Teletransported As Boolean = False)
    Dim OldMap As Integer
    Dim OldX As Integer
    Dim OldY As Integer
    
    With UserList(UserIndex)
        'Quitar el dialogo
        Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageRemoveCharDialog(.Char.CharIndex))
        
        Call WriteRemoveAllDialogs(UserIndex)
        
        If .flags.Embarcado > 0 Then
            Call Barcos(.flags.Embarcado).QuitarPasajero(UserIndex, False)
        End If
        
        OldMap = .Pos.map
        OldX = .Pos.X
        OldY = .Pos.Y
        
        Call EraseUserChar(UserIndex)
        
        If OldMap <> map Then
            Call WriteChangeMap(UserIndex, map)
        End If
        
        If map = 1 Then
            If X <= MinXBorder Then X = MinXBorder + 1
            If Y <= MinYBorder Then Y = MinYBorder + 1
            If X >= MaxXBorder Then X = MaxXBorder - 1
            If Y >= MaxYBorder Then Y = MaxYBorder - 1
        Else
            If X <= 1 Then X = 2
            If Y <= 1 Then Y = 2
            If X >= XMaxMapSize - 1 Then X = XMaxMapSize - 2
            If Y >= YMaxMapSize - 1 Then Y = YMaxMapSize - 2
        End If
        
        .Pos.X = X
        .Pos.Y = Y
        .Pos.map = map
        
        Call CheckZona(UserIndex)
        
        Call MakeUserChar(True, map, UserIndex, map, X, Y)
        Call WriteUserCharIndexInServer(UserIndex)
        
        'Force a flush, so user index is in there before it's destroyed for teleporting
        Call FlushBuffer(UserIndex)
        
        'Seguis invisible al pasar de mapa
        If (.flags.invisible = 1 Or .flags.Oculto = 1) And (Not .flags.AdminInvisible = 1) Then
            
            ' No si estas navegando
            If .flags.Navegando = 0 Then
                Call UsUaRiOs.SetInvisible(UserIndex, .Char.CharIndex, True)
            End If
        End If
        
        If Teletransported Then
            If .flags.Traveling = 1 Then
                .flags.Traveling = 0
                .Counters.goHome = 0
                Call WriteGotHome(UserIndex, False)
            End If
        End If
        
        If FX And .flags.AdminInvisible = 0 Then 'FX
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessagePlayWave(SND_WARP, X, Y))
            Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCreateFX(.Char.CharIndex, FXIDs.FXWARP, 0))
        End If
        
        If .NroMascotas Then Call WarpMascotas(UserIndex)
    End With
End Sub

Private Sub WarpMascotas(ByVal UserIndex As Integer)
'************************************************
'Author: Uknown
'Last Modified: 11/05/2009
'13/02/2009: ZaMa - Arreglado respawn de mascotas al cambiar de mapa.
'13/02/2009: ZaMa - Las mascotas no regeneran su vida al cambiar de mapa (Solo entre mapas inseguros).
'11/05/2009: ZaMa - Chequeo si la mascota pueden spwnear para asiganrle los stats.
'************************************************
    Dim i As Integer
    Dim petType As Integer
    Dim PetRespawn As Boolean
    Dim PetTiempoDeVida As Integer
    Dim NroPets As Integer
    Dim InvocadosMatados As Integer
    Dim canWarp As Boolean
    Dim index As Integer
    Dim iMinHP As Integer
    
    NroPets = UserList(UserIndex).NroMascotas
    canWarp = (Zonas(UserList(UserIndex).Zona).Segura = 0)
    
    For i = 1 To MAXMASCOTAS
        index = UserList(UserIndex).MascotasIndex(i)
        
        If index > 0 Then
            ' si la mascota tiene tiempo de vida > 0 significa q fue invocada => we kill it
            If Npclist(index).Contadores.TiempoExistencia > 0 Then
                Call QuitarNPC(index)
                UserList(UserIndex).MascotasIndex(i) = 0
                InvocadosMatados = InvocadosMatados + 1
                NroPets = NroPets - 1
                
                petType = 0
            Else
                'Store data and remove NPC to recreate it after warp
                'PetRespawn = Npclist(index).flags.Respawn = 0
                petType = UserList(UserIndex).MascotasType(i)
                'PetTiempoDeVida = Npclist(index).Contadores.TiempoExistencia
                
                ' Guardamos el hp, para restaurarlo uando se cree el npc
                iMinHP = Npclist(index).Stats.MinHP
                
                Call QuitarNPC(index)
                
                ' Restauramos el valor de la variable
                UserList(UserIndex).MascotasType(i) = petType

            End If
        ElseIf UserList(UserIndex).MascotasType(i) > 0 Then
            'Store data and remove NPC to recreate it after warp
            PetRespawn = True
            petType = UserList(UserIndex).MascotasType(i)
            PetTiempoDeVida = 0
        Else
            petType = 0
        End If
        
        If petType > 0 And canWarp Then
            index = SpawnNpc(petType, UserList(UserIndex).Pos, False, PetRespawn, UserList(UserIndex).Zona)
            
            'Controlamos que se sumoneo OK - should never happen. Continue to allow removal of other pets if not alone
            ' Exception: Pets don't spawn in water if they can't swim
            If index = 0 Then
                Call WriteConsoleMsg(UserIndex, "Tus mascotas no pueden transitar este mapa.", FontTypeNames.FONTTYPE_INFO)
            Else
                UserList(UserIndex).MascotasIndex(i) = index

                ' Nos aseguramos de que conserve el hp, si estaba da�ado
                
                Npclist(index).Stats.MinHP = IIf(iMinHP = 0, Npclist(index).Stats.MinHP, iMinHP)
            
                Npclist(index).MaestroUser = UserIndex
                Npclist(index).Movement = TipoAI.SigueAmo
                Npclist(index).Target = 0
                Npclist(index).TargetNPC = 0
                Npclist(index).Contadores.TiempoExistencia = PetTiempoDeVida
                Call FollowAmo(index)
            End If
            
            Npclist(index).MaestroUser = UserIndex
            Npclist(index).Movement = TipoAI.SigueAmo
            Npclist(index).Target = 0
            Npclist(index).TargetNPC = 0
            Npclist(index).Contadores.TiempoExistencia = PetTiempoDeVida
            Call FollowAmo(index)
        End If
    Next i
    
    If InvocadosMatados > 0 Then
        Call WriteConsoleMsg(UserIndex, "Pierdes el control de tus mascotas invocadas.", FontTypeNames.FONTTYPE_INFO)
    End If
    
    If Not canWarp Then
        Call WriteConsoleMsg(UserIndex, "No se permiten mascotas en zona segura. �stas te esperar�n afuera.", FontTypeNames.FONTTYPE_INFO)
    End If
    
    UserList(UserIndex).NroMascotas = NroPets
End Sub

''
' Se inicia la salida de un usuario.
'
' @param    UserIndex   El index del usuario que va a salir

Sub Cerrar_Usuario(ByVal UserIndex As Integer)
'***************************************************
'Author: Unknown
'Last Modification: 09/04/08 (NicoNZ)
'
'***************************************************
    Dim isNotVisible As Boolean
    Dim CierraRapido As Boolean
    With UserList(UserIndex)
    If UserList(UserIndex).flags.UserLogged And Not UserList(UserIndex).Counters.Saliendo Then
        UserList(UserIndex).Counters.Saliendo = True
        CierraRapido = Zonas(UserList(UserIndex).Zona).Segura Or EsGM(UserIndex)
        UserList(UserIndex).Counters.Salir = IIf(CierraRapido, 0, IntervaloCerrarConexion)
        
        isNotVisible = (UserList(UserIndex).flags.Oculto Or UserList(UserIndex).flags.invisible)
        If isNotVisible Then
            
        
                If .flags.Oculto Then
                    If .flags.Navegando = 1 Then
                        If .clase = eClass.Pirat Then
                            ' Pierde la apariencia de fragata fantasmal
                            Call ToggleBoatBody(UserIndex)
                            Call WriteConsoleMsg(UserIndex, "�Has recuperado tu apariencia normal!", FontTypeNames.FONTTYPE_INFO)
                            Call ChangeUserChar(UserIndex, .Char.Body, .Char.Head, .Char.Heading, NingunArma, _
                                                NingunEscudo, NingunCasco)
                            'HiddenPirat = True
                        End If
                    End If
                End If
        
                .flags.Oculto = 0
                .flags.invisible = 0
                Call WriteConsoleMsg(UserIndex, "Has vuelto a ser visible.", FontTypeNames.FONTTYPE_INFO)
                If .flags.Navegando = 0 Then
                    Call UsUaRiOs.SetInvisible(UserIndex, .Char.CharIndex, False)
                End If
            
        End If
        
        If .flags.Traveling = 1 Then
                Call WriteGotHome(UserIndex, False)
                .flags.Traveling = 0
                .Counters.goHome = 0
        End If
        
        Call WriteConsoleMsg(UserIndex, "Cerrando...Se cerrar� el juego en " & UserList(UserIndex).Counters.Salir & " segundos...", FontTypeNames.FONTTYPE_INFO)
        
    End If
    End With
End Sub

''
' Cancels the exit of a user. If it's disconnected it's reset.
'
' @param    UserIndex   The index of the user whose exit is being reset.

Public Sub CancelExit(ByVal UserIndex As Integer)
'***************************************************
'Author: Juan Mart�n Sotuyo Dodero (Maraxus)
'Last Modification: 04/02/08
'
'***************************************************
    If UserList(UserIndex).Counters.Saliendo Then
        ' Is the user still connected?
        If UserList(UserIndex).ConnIDValida Then
            UserList(UserIndex).Counters.Saliendo = False
            UserList(UserIndex).Counters.Salir = 0
            Call WriteConsoleMsg(UserIndex, "/salir cancelado.", FontTypeNames.FONTTYPE_WARNING)
        Else
            'Simply reset
            UserList(UserIndex).Counters.Salir = IIf((UserList(UserIndex).flags.Privilegios And PlayerType.user) And Zonas(UserList(UserIndex).Zona).Segura = 0, IntervaloCerrarConexion, 0)
        End If
    End If
End Sub



Sub SendUserStatsTxtOFF(ByVal sendIndex As Integer, ByVal Nombre As String)
    Dim Datos As clsMySQLRecordSet
    Dim Cant As Long
    Cant = mySQL.SQLQuery("SELECT ELV, EXP, ELU, MinSTA, MaxSTA, MinHP, MaxHP, MinMAN,MaxMAN,MinHIT,MaxHIT, GLD, UpTime FROM pjs WHERE Nombre=" & Comillas(Nombre), Datos)
    
    
    If Cant > 0 Then
        Call WriteConsoleMsg(sendIndex, "Pj Inexistente", FontTypeNames.FONTTYPE_INFO)
    Else
        Call WriteConsoleMsg(sendIndex, "Estadisticas de: " & Nombre, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Nivel: " & Datos("ELV") & "  EXP: " & Datos("Exp") & "/" & Datos!ELU, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Vitalidad: " & Datos("MinSta") & "/" & Datos("MaxSta"), FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, "Salud: " & Datos("MinHP") & "/" & Datos!MaxHP & "  Mana: " & Datos("MinMAN") & "/" & Datos!MaxMAN, FontTypeNames.FONTTYPE_INFO)
        
        Call WriteConsoleMsg(sendIndex, "Menor Golpe/Mayor Golpe: " & Datos("MinHIT") & "/" & Datos("MaxHIT"), FontTypeNames.FONTTYPE_INFO)
        
        Call WriteConsoleMsg(sendIndex, "Oro: " & Datos("GLD"), FontTypeNames.FONTTYPE_INFO)
        
#If ConUpTime Then
        Dim TempSecs As Long
        Dim TempStr As String
        TempSecs = Datos!UpTime
        TempStr = (TempSecs \ 86400) & " Dias, " & ((TempSecs Mod 86400) \ 3600) & " Horas, " & ((TempSecs Mod 86400) Mod 3600) \ 60 & " Minutos, " & (((TempSecs Mod 86400) Mod 3600) Mod 60) & " Segundos."
        Call WriteConsoleMsg(sendIndex, "Tiempo Logeado: " & TempStr, FontTypeNames.FONTTYPE_INFO)
#End If
    
    End If
End Sub

Sub SendUserOROTxtFromChar(ByVal sendIndex As Integer, ByVal charName As String)
   
On Error Resume Next
    
    If PersonajeExiste(charName) Then
        Call WriteConsoleMsg(sendIndex, charName, FontTypeNames.FONTTYPE_INFO)
        Call WriteConsoleMsg(sendIndex, " Tiene " & GetByCampo("SELECT Banco FROM pjs WHERE Nombre=" & Comillas(charName), "Banco") & " en el banco.", FontTypeNames.FONTTYPE_INFO)
    Else
        Call WriteConsoleMsg(sendIndex, "Usuario inexistente: " & charName, FontTypeNames.FONTTYPE_INFO)
    End If
End Sub

Sub VolverCriminal(ByVal UserIndex As Integer)
'**************************************************************
'Author: Unknown
'Last Modify Date: 21/06/2006
'Nacho: Actualiza el tag al cliente
'**************************************************************
    With UserList(UserIndex)
        If MapData(.Pos.map, .Pos.X, .Pos.Y).Trigger = eTrigger.ZONAPELEA Then Exit Sub
        
        If .flags.Privilegios And (PlayerType.user Or PlayerType.Consejero) Then
            .Reputacion.BurguesRep = 0
            .Reputacion.NobleRep = 0
            .Reputacion.PlebeRep = 0
            .Reputacion.BandidoRep = .Reputacion.BandidoRep + vlASALTO
            If .Reputacion.BandidoRep > MAXREP Then .Reputacion.BandidoRep = MAXREP
            If .Faccion.ArmadaReal = 1 Then Call ExpulsarFaccionReal(UserIndex)
        End If
    End With
    
    Call RefreshCharStatus(UserIndex)
End Sub

Sub VolverCiudadano(ByVal UserIndex As Integer)
'**************************************************************
'Author: Unknown
'Last Modify Date: 21/06/2006
'Nacho: Actualiza el tag al cliente.
'**************************************************************
    With UserList(UserIndex)
        If MapData(.Pos.map, .Pos.X, .Pos.Y).Trigger = 6 Then Exit Sub
        
        .Reputacion.LadronesRep = 0
        .Reputacion.BandidoRep = 0
        .Reputacion.AsesinoRep = 0
        .Reputacion.PlebeRep = .Reputacion.PlebeRep + vlASALTO
        If .Reputacion.PlebeRep > MAXREP Then .Reputacion.PlebeRep = MAXREP
    End With
    
    Call RefreshCharStatus(UserIndex)
End Sub

''
'Checks if a given body index is a boat or not.
'
'@param body    The body index to bechecked.
'@return    True if the body is a boat, false otherwise.

Public Function BodyIsBoat(ByVal Body As Integer) As Boolean
'**************************************************************
'Author: Juan Mart�n Sotuyo Dodero (Maraxus)
'Last Modify Date: 10/07/2008
'Checks if a given body index is a boat
'**************************************************************
'TODO : This should be checked somehow else. This is nasty....
    If Body = iFragataReal Or Body = iFragataCaos Or Body = iBarcaPk Or _
            Body = iGaleraPk Or Body = iGaleonPk Or Body = iBarcaCiuda Or _
            Body = iGaleraCiuda Or Body = iGaleonCiuda Or Body = iFragataFantasmal Then
        BodyIsBoat = True
    End If
End Function
Public Function Criminal(ByVal UserIndex As Integer) As Boolean

Dim L As Long
L = (-UserList(UserIndex).Reputacion.AsesinoRep) + _
    (-UserList(UserIndex).Reputacion.BandidoRep) + _
    UserList(UserIndex).Reputacion.BurguesRep + _
    (-UserList(UserIndex).Reputacion.LadronesRep) + _
    UserList(UserIndex).Reputacion.NobleRep + _
    UserList(UserIndex).Reputacion.PlebeRep
L = L / 6
Criminal = (L < 0)

End Function


Public Sub CheckZona(ByVal UserIndex As Integer)
Dim i As Integer
With UserList(UserIndex)
If .Zona > 0 Then
    If Zonas(.Zona).Acoplar = 0 Then
        If .Pos.map = Zonas(.Zona).mapa And .Pos.X >= Zonas(.Zona).X1 And .Pos.X <= Zonas(.Zona).X2 And .Pos.Y >= Zonas(.Zona).Y1 And .Pos.Y <= Zonas(.Zona).Y2 Then
            'Ya no esta mas en la zona que estaba
            Exit Sub
        End If
    End If
End If
.Zona = BuscarZona(.Pos.map, .Pos.X, .Pos.Y)
If .Zona = 0 Then
    .Zona = IIf(HayAgua(.Pos.map, .Pos.X, .Pos.Y), 24, 23)
End If
End With
End Sub
Public Sub CheckZonaNPC(ByVal NpcIndex As Integer)
With Npclist(NpcIndex)
If .Zona > 0 Then
    If .Pos.map = Zonas(.Zona).mapa And .Pos.X >= Zonas(.Zona).X1 And .Pos.X <= Zonas(.Zona).X2 And .Pos.Y >= Zonas(.Zona).Y1 And .Pos.Y <= Zonas(.Zona).Y2 Then
        'Ya no esta mas en la zona que estaba
        Exit Sub
    End If
End If
.Zona = BuscarZona(.Pos.map, .Pos.X, .Pos.Y)
If .Zona = 0 Then
    .Zona = IIf(HayAgua(.Pos.map, .Pos.X, .Pos.Y), 24, 23)
End If
End With
End Sub
Public Function BuscarZona(map As Integer, X As Integer, Y As Integer) As Integer
Dim i As Integer
For i = 1 To NumZonas
    If map = Zonas(i).mapa And X >= Zonas(i).X1 And X <= Zonas(i).X2 And Y >= Zonas(i).Y1 And Y <= Zonas(i).Y2 Then
        BuscarZona = i
        If Zonas(i).Acoplar = 0 Then Exit Function
    End If
Next i
BuscarZona = 0
End Function

Public Function AreaUser(ByVal UserIndex As Integer) As Integer
Dim i As Integer
With UserList(UserIndex)
For i = 1 To NumAreas
    If .Pos.map = Areas(i).mapa And .Pos.X >= Areas(i).X1 And .Pos.X <= Areas(i).X2 And .Pos.Y >= Areas(i).Y1 And .Pos.Y <= Areas(i).Y2 Then
        AreaUser = i
        Exit Function
    End If
Next i
End With
AreaUser = 0
End Function

Public Sub userGoHome(ByVal UserIndex As Integer)
'***************************************************
'Author: Budi
'Last Modification: 01/06/2010
'01/06/2010: ZaMa - Ahora usa otro tipo de intervalo (lo saque de tPiquetec)
'***************************************************

    Dim Dist As Long
    Dim Tiempo As Long
    
    With UserList(UserIndex)
        If .flags.Muerto = 1 Then
            If .Pos.map = 1 Then
                Dist = (Distance(.Pos.X, .Pos.Y, Hogares(.Hogar).X, Hogares(.Hogar).Y) + 1) / 10 + 2
            Else
                Dist = 150
            End If
            
            If .Stats.ELV < 25 Then
                If .Pos.map = 1 Then
                    Tiempo = MinimoInt(Dist, 20)
                Else
                    Tiempo = 40
                End If
            Else
                Tiempo = Dist * (1 + (.Stats.ELV - 25) / 180) + 10
            End If
            

            Call IntervaloGoHome(UserIndex, Tiempo * 1000, True)
                
            Call WriteGoHome(UserIndex, Tiempo)
        Else
            Call WriteConsoleMsg(UserIndex, "Debes estar muerto para poder utilizar este comando.", FontTypeNames.FONTTYPE_FIGHT)
        End If
        
    End With
    
End Sub
Public Function GetHomeArrivalTime(ByVal UserIndex As Integer) As Long
'**************************************************************
'Author: ZaMa
'Last Modify by: ZaMa
'Last Modify Date: 01/06/2010
'Calculates the time left to arrive home.
'**************************************************************
    Dim TActual As Long
    
    TActual = (GetTickCount() And &H7FFFFFFF)
    
    With UserList(UserIndex)
        GetHomeArrivalTime = getInterval(.Counters.goHome, TActual) * 0.001
    End With

End Function

Public Sub HomeArrival(ByVal UserIndex As Integer)
'**************************************************************
'Author: ZaMa
'Last Modify by: ZaMa
'Last Modify Date: 01/06/2010
'Teleports user to its home.
'**************************************************************
    
    Dim tX As Integer
    Dim tY As Integer
    Dim tMap As Integer

    With UserList(UserIndex)

        'Antes de que el pj llegue a la ciudad, lo hacemos dejar de navegar para que no se buguee.
        If .flags.Navegando = 1 Then
            .Char.Body = iCuerpoMuerto
            .Char.Head = iCabezaMuerto
            .Char.ShieldAnim = NingunEscudo
            .Char.WeaponAnim = NingunArma
            .Char.CascoAnim = NingunCasco
            
            .flags.Navegando = 0
            
            Call WriteNavigateToggle(UserIndex)
            'Le sacamos el navegando, pero no le mostramos a los dem�s porque va a ser sumoneado hasta ulla.
        End If
        
        tX = Hogares(.Hogar).X
        tY = Hogares(.Hogar).Y
        tMap = Hogares(.Hogar).map
        
        Call FindLegalPos(UserIndex, tMap, tX, tY)
        Call WarpUserChar(UserIndex, tMap, tX, tY, False)
        Call DoTileEvents(UserIndex, tMap, tX, tY)
        
        Call WriteGotHome(UserIndex, True)
        
        .flags.Traveling = 0
        .Counters.goHome = 0
        
    End With
    
End Sub
Public Sub setHome(ByVal UserIndex As Integer, ByVal newHome As eCiudad, ByVal NpcIndex As Integer)
'***************************************************
'Author: Budi
'Last Modification: 01/06/2010
'30/04/2010: ZaMa - Ahora el npc avisa que se cambio de hogar.
'01/06/2010: ZaMa - Ahora te avisa si ya tenes ese hogar.
'***************************************************
    If newHome < eCiudad.cUllathorpe Or newHome > eCiudad.cLastCity - 1 Then Exit Sub
    
    If UserList(UserIndex).Hogar <> newHome Then
        UserList(UserIndex).Hogar = newHome
    
        Call WriteChatOverHead(UserIndex, "�Bienvenido a nuestra humilde comunidad, este es ahora tu nuevo hogar!", Npclist(NpcIndex).Char.CharIndex, vbWhite)
    Else
        Call WriteChatOverHead(UserIndex, "�Ya eres miembro de nuestra humilde comunidad!", Npclist(NpcIndex).Char.CharIndex, vbWhite)
    End If

End Sub
Public Sub SetInvisible(ByVal UserIndex As Integer, ByVal userCharIndex As Integer, ByVal invisible As Boolean)
'***************************************************
'Author: Unknown
'Last Modification: -
'
'***************************************************

Dim sndNick As String

With UserList(UserIndex)
    Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageSetInvisible(userCharIndex, invisible))
    
    'sndNick = .Name
    
    'If invisible Then
    '    sndNick = sndNick & " " & 1
    'Else
    '    If .GuildIndex > 0 Then
    '        sndNick = sndNick & " <" & modGuilds.GuildName(.GuildIndex) & ">"
    '    End If
    'End If
    
    'Call SendData(SendTarget.ToPCArea, UserIndex, PrepareMessageCharacterChangeNick(userCharIndex, sndNick))
End With
End Sub
