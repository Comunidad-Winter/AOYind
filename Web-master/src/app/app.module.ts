import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { InicioComponent } from './componentes/inicio/inicio.component';
import { GaleriaComponent } from './componentes/galeria/galeria.component';
import { RankingComponent } from './componentes/ranking/ranking.component';
import { NoticiaComponent } from './componentes/noticia/noticia.component';
import { WikiComponent } from './componentes/wiki/wiki.component';
import { EquipoComponent } from './componentes/equipo/equipo.component';
import { FotosComponent } from './componentes/fotos/fotos.component';
import { NoticiaMovilComponent } from './componentes/noticia-movil/noticia-movil.component';
import { EquipoMovilComponent } from './componentes/equipo-movil/equipo-movil.component';
import { LicenciaComponent } from './componentes/licencia/licencia.component';

@NgModule({
  declarations: [
    AppComponent,
    InicioComponent,
    GaleriaComponent,
    RankingComponent,
    NoticiaComponent,
    WikiComponent,
    EquipoComponent,
    FotosComponent,
    NoticiaMovilComponent,
    EquipoMovilComponent,
    LicenciaComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
