/**
 * Agent Script action implementation for Cascade_Service_Agent's
 * "get_case_status" action (target: apex://CascadeCaseStatusLookup).
 *
 * Looks up an existing Case by CaseNumber and confirms it belongs to the
 * messaging end user's Contact before returning its status.
 */
public with sharing class CascadeCaseStatusLookup {

    @InvocableMethod(
        label='Look Up Case Status'
        description='Looks up the current status of an existing support case by case number'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();

        Set<String> caseNumbers = new Set<String>();
        for (Request req : requests) {
            if (req.caseNumber != null) {
                caseNumbers.add(req.caseNumber);
            }
        }

        Map<String, Case> caseByNumber = new Map<String, Case>();
        if (!caseNumbers.isEmpty()) {
            for (Case c : [
                SELECT CaseNumber, Status, Subject, LastModifiedDate, ContactId
                FROM Case
                WHERE CaseNumber IN :caseNumbers
                WITH USER_MODE
            ]) {
                caseByNumber.put(c.CaseNumber, c);
            }
        }

        for (Request req : requests) {
            Result r = new Result();
            r.found = false;

            Case c = caseByNumber.get(req.caseNumber);
            // Fail closed: without an identified contact we cannot confirm the
            // case belongs to the person asking. Case numbers are sequential
            // and therefore guessable, so an unidentified caller must not be
            // able to read another customer's case.
            Boolean contactMatches = c != null
                && req.contactId != null
                && c.ContactId == req.contactId;

            if (c != null && contactMatches) {
                r.status = c.Status;
                r.subject = c.Subject;
                r.lastModified = String.valueOf(c.LastModifiedDate);
                r.found = true;
            }

            results.add(r);
        }

        return results;
    }

    public class Request {
        @InvocableVariable(
            label='Case Number'
            description='The case number the user is asking about'
            required=true
        )
        public String caseNumber;

        @InvocableVariable(
            label='Contact ID'
            description='Contact ID of the messaging end user, used to confirm the case belongs to them'
        )
        public String contactId;
    }

    public class Result {
        @InvocableVariable(
            label='Status'
            description='Current case status'
        )
        public String status;

        @InvocableVariable(
            label='Subject'
            description='Case subject'
        )
        public String subject;

        @InvocableVariable(
            label='Last Modified'
            description='When the case was last updated'
        )
        public String lastModified;

        @InvocableVariable(
            label='Found'
            description='Whether a case matching the number and contact was found'
        )
        public Boolean found;
    }
}