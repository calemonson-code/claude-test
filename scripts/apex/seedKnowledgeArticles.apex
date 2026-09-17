// Seeds the 8 Cascade Outdoor Supply knowledge articles for the Cascade
// Service Agent's KNOWLEDGE-source-type ADL (see
// Cascade_Service_Agent-AgentSpec.md, "Why this replaced the Apex approach").
// Source content: Cascade_Knowledge_Articles.md (from SOW v1.0, Section 2.2),
// condensed to fit Knowledge__kav.Summary's 1000-character limit, which is
// the only content field on this org's Knowledge Article Type (plain long
// text area, not rich text).
// Each article's SOW §2.2.2 support category is noted in a comment — there is
// no Data Category Group deployed in this org, so category is not stored on
// the record itself.
//
// Run with: SFDX: Execute Anonymous Apex with Editor Contents

List<Knowledge__kav> articles = new List<Knowledge__kav>{
    // Category: Returns
    new Knowledge__kav(
        Title = 'Our Return Policy',
        UrlName = 'our-return-policy',
        Language = 'en_US',
        Summary = 'Cascade accepts returns within 60 days of delivery on most items. Gear must be unused, in original packaging, with proof of purchase; items showing field use go through our repair and warranty process instead.\n\n' +
            'Not returnable: climbing hardware, harnesses, ropes, and other load-bearing safety equipment; Final Sale items; gift cards; and consumables like nutrition and fuel canisters.\n\n' +
            'Refunds go to the original payment method and typically appear within 5-7 business days after we receive and inspect the return. Return shipping is free within the US; international customers cover return shipping.\n\n' +
            'If your item arrived damaged or defective, don\'t use this process - see "Damaged or Defective Items on Arrival" instead.'
    ),
    // Category: Orders and Shipping
    new Knowledge__kav(
        Title = 'How to Track Your Order',
        UrlName = 'how-to-track-your-order',
        Language = 'en_US',
        Summary = 'Every Cascade order gets a tracking number as soon as it ships, sent to the email on the order. You can also find it in your account under Order History.\n\n' +
            'Tracking can take up to 24 hours to show movement. If it hasn\'t updated after two business days, the package may be delayed in transit.\n\n' +
            'Orders with multiple items may ship in more than one box, each with its own tracking number - your order isn\'t incomplete just because one box arrives first.\n\n' +
            'If tracking shows delivered but you don\'t have your package, check with neighbors and building management first, then contact us so we can open a case and work it with the carrier.'
    ),
    // Category: Orders and Shipping
    new Knowledge__kav(
        Title = 'Shipping Options and Delivery Times',
        UrlName = 'shipping-options-and-delivery-times',
        Language = 'en_US',
        Summary = 'Delivery times count business days from when your order ships, not when you place it. Orders placed before 1:00 PM Pacific ship the same day.\n\n' +
            'Standard: 5-7 business days, free over $75 (otherwise $8.95). Expedited: 2-3 business days, $16.95. Overnight: next business day, $34.95 (order before 11:00 AM Pacific).\n\n' +
            'We ship to all 50 states. Alaska and Hawaii are Standard only, typically 7-10 business days. We also ship to Canada and Mexico; duties and import taxes are the customer\'s responsibility, collected by the carrier on delivery.\n\n' +
            'Oversized items - kayaks, canoes, and rooftop cargo boxes - ship freight and are quoted separately at checkout.'
    ),
    // Category: Returns
    new Knowledge__kav(
        Title = 'Exchanges and Finding the Right Size',
        UrlName = 'exchanges-and-finding-the-right-size',
        Language = 'en_US',
        Summary = 'We don\'t process direct exchanges. To swap for a different size or color, return the original for a refund and place a new order - that way you\'re not waiting on the return before your replacement ships.\n\n' +
            'Sizing runs true to each manufacturer\'s chart, and charts vary by brand; each product page links the chart for that brand. For boots, measure your foot late in the day and size up a half size if you\'ll wear thick hiking socks.\n\n' +
            'For layering pieces, check whether the item is a base layer, mid layer, or shell - base layers are meant to fit close, so a snug base layer is usually correct.\n\n' +
            'If you\'re between sizes, log a case and our support team will help you choose before you order.'
    ),
    // Category: Orders and Shipping
    new Knowledge__kav(
        Title = 'Damaged or Defective Items on Arrival',
        UrlName = 'damaged-or-defective-items-on-arrival',
        Language = 'en_US',
        Summary = 'If your gear arrives damaged or with a manufacturing defect, don\'t use the standard return process. Contact us within 14 days of delivery and we\'ll handle it directly.\n\n' +
            'Have ready: your order number, a short description of the problem, and photos of the damage (including the shipping box if it was damaged too).\n\n' +
            'We\'ll ship a free replacement or issue a full refund including shipping, whichever you prefer. Damage from field use - abrasion, punctures, worn seams - isn\'t a defect on arrival and goes through our repair and warranty process instead.\n\n' +
            'Keep the packaging until your claim is resolved; carriers sometimes require inspection.'
    ),
    // Category: Product Care
    new Knowledge__kav(
        Title = 'Caring for Your Tent',
        UrlName = 'caring-for-your-tent',
        Language = 'en_US',
        Summary = 'A tent stored wet will not last - dry it fully, inside and out, after every trip before packing it away, and shake out sand and grit, which abrade the floor coating fastest.\n\n' +
            'Cleaning: sponge with cool water and a non-detergent soap. Never machine wash or dry, and don\'t use bleach or fabric softener - all strip the waterproof coating.\n\n' +
            'Zippers: rinse out grit and run a dry lubricant along them once a season. A blown zipper - almost always caused by grit - is the most common tent repair we see.\n\n' +
            'Storage: keep it loose in a breathable bag, not compressed in the stuff sack; long-term compression creates leak points.\n\n' +
            'Re-proofing: when water stops beading on the fly, the DWR finish has worn through. A spray-on re-proofer restores it - that\'s normal wear, not a defect.'
    ),
    // Category: Product Care
    new Knowledge__kav(
        Title = 'Caring for Down and Synthetic Insulation',
        UrlName = 'caring-for-down-and-synthetic-insulation',
        Language = 'en_US',
        Summary = 'Insulation works by trapping air - dirt, body oils, and compression mat the fill flat and reduce warmth. Store sleeping bags and jackets uncompressed in the mesh sack they ship with, not the stuff sack, between trips.\n\n' +
            'Washing down: use a down-specific wash in a front-loading machine on gentle, then tumble dry low with a few tennis balls to break up clumps. It takes several hours - stopping early leaves damp clumps that can mildew.\n\n' +
            'Washing synthetic: mild detergent, gentle cycle, tumble dry low; more forgiving than down, but still dry it completely.\n\n' +
            'For collar and cuff grime, spot clean with diluted soap on a cloth rather than washing the whole garment - every wash costs some loft.\n\n' +
            'If loft doesn\'t return after a proper wash and dry, the fill may be past its life; log a case with photos.'
    ),
    // Category: Support
    new Knowledge__kav(
        Title = 'Checking the Status of Your Support Case',
        UrlName = 'checking-the-status-of-your-support-case',
        Language = 'en_US',
        Summary = 'When you contact Cascade support, we open a case and email you a case number - keep it, it\'s the fastest way for us to find your issue. Check status by giving your case number to our support assistant in chat, or by signing in and opening Support History.\n\n' +
            'Cases move through: New (received, not picked up), In Progress (an agent is working it), Waiting on Customer (we need info from you), Escalated (routed to a specialist team), and Closed (resolved).\n\n' +
            'If your case shows Waiting on Customer, check your email - we\'ve asked a question and the case won\'t move until you reply.\n\n' +
            'Our first response target is one business day; cases opened over a weekend are typically picked up the next business day.'
    )
};
insert articles;

List<Knowledge__kav> inserted = [
    SELECT Id, KnowledgeArticleId
    FROM Knowledge__kav
    WHERE Id IN :articles
];
for (Knowledge__kav a : inserted) {
    KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);
}

System.debug('Published ' + inserted.size() + ' Cascade knowledge articles.');
