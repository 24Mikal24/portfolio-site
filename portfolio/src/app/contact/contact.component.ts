import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './contact.component.html',
  styleUrl: './contact.component.css'
})
export class ContactComponent {
  form: FormGroup;

  constructor(private http: HttpClient, private formBuilder: FormBuilder) {
    this.form = this.formBuilder.group({
      name: ['', Validators.required],
      email: ['', Validators.required],
      subject: ['', Validators.required],
      message: ['', Validators.required]
    });
  }

  sendEmail() {
    this.http.post('https://0eu6lmq8g2.execute-api.us-east-1.amazonaws.com/default/contactFormLambda', this.form.value).subscribe({
      next: (res) => this.displaySuccessMessage(),
      error: (err) => this.displayErrorMessage()
    });
  }

  displaySuccessMessage() {
    this.form.reset();
    console.log("Successfully sent email");
  }

  displayErrorMessage() {
    this.form.reset();
    console.log("There was an issue sending your message");
  }
}
