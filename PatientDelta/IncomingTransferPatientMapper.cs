﻿using System;
using PatientDelta.PatientDeltaModel;

namespace PatientDelta
{
    public class IncomingTransferPatientMapper : IIncomingTransferPatientMapper
    {
        public Patient Map(IncomingTransferPatientModel patient)
        {
            return new Patient()
            {
                PatientName = patient.PatientName,
                Status = "Pending",
                Requester = patient.Requester,
                RequestDate = DateTime.Now,
                NhsNumber = patient.NhsNumber
            };
        }
    }
}
