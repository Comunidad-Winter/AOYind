import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { EquipoComponent } from './componentes/equipo/equipo.component';
import { FotosComponent } from './componentes/fotos/fotos.component';
import { InicioComponent } from './componentes/inicio/inicio.component';
import { WikiComponent } from './componentes/wiki/wiki.component';


const routes: Routes = [
  {
    path: '**',
    component: InicioComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
