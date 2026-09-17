/**
 * Agent Script action implementation for Cascade_Service_Agent's
 * "create_case" action (target: apex://CascadeCaseCreator).
 *
 * Logs a new support case for the messaging end user's Contact.
 */
public with sharing class CascadeCaseCreator {

    @InvocableMethod(
        label='Create Support Case'
        description='Creates a new support case for the end user'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Case> casesToInsert = new List<Case>();

        for (Request req : requests) {
            Case c = new Case();
            c.Subject = req.subject;
            c.Description = req.problemDescription;
            if (req.contactId != null) {
                c.ContactId = req.contactId;
            }
            casesToInsert.add(c);
        }

        insert as user casesToInsert;

        List<Result> results = new List<Result>();
        for (Case c : casesToInsert) {
            Result r = new Result();
            r.caseNumber = c.CaseNumber;
            r.caseId = c.Id;
            results.add(r);
        }

        return results;
    }

    public class Request {
        @InvocableVariable(
            label='Subject'
            description='Short summary of the user\'s problem'
            required=true
        )
        public String subject;

        @InvocableVariable(
            label='Problem Description'
            description='Fuller description of the problem in the user\'s own words'
            required=true
        )
        public String problemDescription;

        @InvocableVariable(
            label='Contact ID'
            description='Contact ID of the messaging end user'
        )
        public String contactId;
    }

    public class Result {
        @InvocableVariable(
            label='Case Number'
            description='Case number of the newly created case'
        )
        public String caseNumber;

        @InvocableVariable(
            label='Case ID'
            description='Record ID of the newly created case'
        )
        public String caseId;
    }
}
