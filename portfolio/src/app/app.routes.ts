import { Routes } from '@angular/router';
import { ResumeComponent } from './resume/resume.component';
import { ContactComponent } from './contact/contact.component';

export const routes: Routes = [
    { path: 'resume', component: ResumeComponent },
    { path: 'contact', component: ContactComponent }
];
