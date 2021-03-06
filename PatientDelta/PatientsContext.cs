﻿using System;
using Microsoft.EntityFrameworkCore;
using PatientDelta.PatientDeltaModel;

namespace PatientDelta
{
    public class PatientsContext : DbContext
    {
        public DbSet<Patient> Patients { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
            => optionsBuilder.UseSqlite($"Data Source=patients.db");
    }
}
