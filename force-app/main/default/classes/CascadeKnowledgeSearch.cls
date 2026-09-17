/**
 * Agent Script action implementation for Cascade_Service_Agent's
 * "search_knowledge" action (target: apex://CascadeKnowledgeSearch).
 *
 * Searches published Knowledge articles for an answer to the end user's
 * support question and returns the top match.
 */
public with sharing class CascadeKnowledgeSearch {

    @InvocableMethod(
        label='Search Support Knowledge Base'
        description='Searches the support knowledge base for an answer to the user\'s question'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();

        for (Request req : requests) {
            Result r = new Result();
            r.foundMatch = false;

            List<List<Knowledge__kav>> searchResults = [
                FIND :req.question IN ALL FIELDS
                RETURNING Knowledge__kav(
                    Id, Title, Summary, UrlName
                    WHERE PublishStatus = 'Online' AND Language = 'en_US'
                    LIMIT 1
                )
            ];

            if (!searchResults.isEmpty() && !searchResults[0].isEmpty()) {
                Knowledge__kav article = searchResults[0][0];
                r.answer = article.Summary;
                r.articleTitle = article.Title;
                r.articleUrl = '/knowledge/publishing/articleOnlineDetail.apexp?urlname=' + article.UrlName;
                r.foundMatch = true;
            }

            results.add(r);
        }

        return results;
    }

    public class Request {
        @InvocableVariable(
            label='Question'
            description='The user\'s support question, in their own words'
            required=true
        )
        public String question;
    }

    public class Result {
        @InvocableVariable(
            label='Answer'
            description='Answer text drawn from the matching article'
        )
        public String answer;

        @InvocableVariable(
            label='Article Title'
            description='Title of the matching article'
        )
        public String articleTitle;

        @InvocableVariable(
            label='Article URL'
            description='Link to the matching article'
        )
        public String articleUrl;

        @InvocableVariable(
            label='Found Match'
            description='Whether the search found a usable article'
        )
        public Boolean foundMatch;
    }
}