import { Routes } from '@angular/router';
import { ResumeComponent } from './resume/resume.component';
import { ContactComponent } from './contact/contact.component';
import { AboutComponent } from './about/about.component';

export const routes: Routes = [
    { path: 'about', component: AboutComponent, data: {pageTitle: 'About'} },
    { path: 'contact', component: ContactComponent, data: {pageTitle: 'Contact'} },
    { path: 'resume', component: ResumeComponent, data: {pageTitle: 'Resume'} }
];
