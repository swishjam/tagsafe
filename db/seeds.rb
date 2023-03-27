
# puts "Purging existing seed data."
# domain_urls = %w[https://www.tagsafe.io htps://www.google.com https://www.quantummetric.com]
# script_urls = %w[
#   https://cdn.collin.com/js/script.js
#   https://cdn.optimizely.com/script.js
#   https://cdn.medallia.com/script.js
#   https://cdn.qualtrics.com/survey.js
#   https://cdn.gigya.com/script.js
#   https://cdn.speedcurve.com/monitor.js
#   https://cdn.rigor.com/scripts.js
#   https://www.catchpoint.com/scripts/tag.js
# ]

# domain_urls.each { |u| Domain.find_by(url: u)&.destroy! }
# script_urls.each { |u| Tag.find_by(url: u)&.destroy! }

# puts "Creating Domains."
# org = Organization.find_or_create_by(name: 'Seeded Organization')
# unless User.find_by(email: 'seed@gmail.com')
#   User.create(email: 'seed@gmail.com', password: 'seed123', organization: org)
# end
# domain_urls.each do |url|
#   unless Domain.find_by(url: url)
#     Domain.without_callbacks do
#       puts "Creating domain #{url}"
#       Domain.create(organization: org, url: url)
#     end
#   else
#     puts "Domain #{url} already exists, skipping."
#   end
# end

# puts "Creating Tags and Tag Changes."
# def seed_tag_versions_for_script(script)
#   unless script.tag_versions.any?
#     TagVersion.without_callbacks do
#       5.times do |i|
#         puts "Creating script change."
#         TagVersion.create(
#           script: script,
#           hashed_content: SecureRandom.hex(8),
#           bytes: 1,
#           created_at: DateTime.now - (i.days*rand(10))
#         )
#       end
#     end
#     most_recent = script.tag_versions.most_recent_first.first
#     most_recent.make_most_recent!
#     most_recent.set_script_last_released_at_timestamp
#   end
#   script.tag_versions
# end

# def create_audit(tag_version, tag, execution_reason: ExecutionReason.NEW_RELEASE)
#   puts "Creating audit."
#   Audit.create(
#     tag_version: tag_version,
#     tag: tag,
#     execution_reason: execution_reason,
#     lighthouse_audit_enqueued_at: execution_reason == ExecutionReason.NEW_RELEASE ? tag_version.created_at : tag_version.created_at + 1.hour,
#     lighthouse_audit_url: tag.reload.lighthouse_preferences.page_url_to_perform_audit_on
#   )
# end

# def create_audits_for_tag_versions(tag, tag_versions)
#   unless tag.audits.any?
#     tag_versions.each do |tag_version|
#       create_audit(tag_version, tag)
#       create_audit(tag_version, tag, execution_reason: ExecutionReason.MANUAL)
#     end
#   end
#   tag.audits
# end

# def generate_lighthouse_audit_result(value_multiplier = 10, score_multiplier = 10)
#   {
#     "max-potential-fid" => { "value" => (5*value_multiplier), "score" => (0.1*score_multiplier) },
#     "largest-contentful-paint" => { "value" => (50*value_multiplier), "score" => (0.1*score_multiplier) },
#     "first-meaningful-paint" => { "value" => (50*value_multiplier), "score" => (0.1*score_multiplier) },
#     "first-contentful-paint" => { "value" => (50*value_multiplier), "score" => (0.1*score_multiplier) },
#     "estimated-input-latency" => { "value" => (1*value_multiplier), "score" => (0.1*score_multiplier) },
#     "cumulative-layout-shift" => { "value" => (0.1)*value_multiplier, "score" => (0.1*score_multiplier) },
#     "first-cpu-idle" => { "value" => (70*value_multiplier), "score" => (0.1*score_multiplier) },
#     "total-byte-weight" => { "value" => (200*value_multiplier),"score" => (0.1*score_multiplier) },
#     "speed-index" => { "value" => (80*value_multiplier),"score" => (0.1*score_multiplier) },
#     "render-blocking-resources" => { "value" => (50*value_multiplier),"score" => (0.1*score_multiplier) },
#     "network-rtt" => { "value" => (0.00687*value_multiplier),"score" => nil },
#     "interactive" => { "value" => (70*value_multiplier),"score" => (0.1*score_multiplier) },
#     "total-blocking-time" => { "value" => (10*value_multiplier),"score" => (0.1*score_multiplier) },
#     "mainDocumentTransferSize" => { "value" =>  (40*value_multiplier) },
#     "maxRtt" => { "value" => (0.00687*value_multiplier) },
#     "maxServerLatency" => { "value" => (0.1*value_multiplier) },
#     "numFonts" => { "value" => (0*value_multiplier) },
#     "numRequests" => { "value" => (1*value_multiplier) },
#     "numTags" => { "value" => (2*value_multiplier) },
#     "numStylesheets" => { "value" => (1*value_multiplier) },
#     "numTasks" => { "value" => (30*value_multiplier) },
#     "numTasksOver10ms" => { "value" => (4*value_multiplier) },
#     "numTasksOver25ms" => { "value" => (3*value_multiplier) },
#     "numTasksOver50ms" => { "value" => (2*value_multiplier) },
#     "numTasksOver100ms" => { "value" => (1*value_multiplier) },
#     "numTasksOver500ms" => { "value" => (0*value_multiplier) },
#     "rtt" => { "value" => (0.0015*value_multiplier) },
#     "throughput" => { "value" => (40_000*value_multiplier) },
#     "totalByteWeight" => { "value" => (2000*value_multiplier) },
#     "totalTaskTime" => { "value" => (50*value_multiplier) }
#     # "lighthouse_report_url":"http://localhost:3000/public/lighthouse-reports/report-1601770307147.html"
#   }
# end

# def create_random_results_with_tag
#   [
#     generate_lighthouse_audit_result(Util.random_float(8, 10).round(2), Util.random_float(9, 10).round(2)),
#     generate_lighthouse_audit_result(Util.random_float(10, 15).round(2), Util.random_float(6, 8).round(2)),
#     generate_lighthouse_audit_result(Util.random_float(9, 12).round(2), Util.random_float(8, 9).round(2))
#   ]
# end

# def create_random_results_without_tag
#   3.times.map{ generate_lighthouse_audit_result(Util.random_float(8, 10).round(2), Util.random_float(9, 10).round(2)) }
# end

# def create_lighthouse_audits_for_audits(audits)
#   audits.each do |audit|
#     puts "Creating lighthouse audit."
#     LighthouseManager::ResultsHandler.new(
#       error: nil,
#       results_with_tag: create_random_results_with_tag,
#       results_without_tag: create_random_results_without_tag, 
#       audit_id: audit.id
#     ).capture_results!
#   end
# end

# domains = domain_urls.map{ |url| Domain.find_by(url: url) }

# script_urls.each do |url|
#   script = Tag.find_or_create_by(url: url)
#   tag_versions = seed_tag_versions_for_script(script)
#   domains.each do |domain|
#     tag = domain.has_tag?(script) ? domain.tags.find_by(script_id: script.id) : domain.add_tag!(script, active: true, enabled: false)
#     audits = create_audits_for_tag_versions(tag, tag_versions)
#     create_lighthouse_audits_for_audits(audits)
#   end
# end

# puts "Completed seed."
