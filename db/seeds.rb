def seed_user(name, email_address)
  User.find_or_create_by!(email_address: email_address) do |user|
    user.name = name
    user.password = "password"
  end
end

def seed_membership(account, user, role = :member)
  account.memberships.find_or_create_by!(user: user) { |membership| membership.role = role }
end

def seed_project(account, name, creator:, description:, assigned:)
  project = account.projects.find_or_create_by!(name: name) do |p|
    p.creator = creator
    p.description = description
  end

  assigned.each { |user| project.assignments.find_or_create_by!(user: user) }
  project
end

def seed_comments(project, comments)
  return if project.comments.exists?

  now = Time.current
  rows = comments.each_with_index.map do |(creator, body), index|
    created_at = now - (comments.size - index) * 7.hours
    { project_id: project.id, creator_id: creator.id, body: body, created_at: created_at, updated_at: created_at }
  end

  Comment.insert_all!(rows)
end

def seed_device(user, name, platform:, token:, last_seen_at:)
  user.devices.find_or_create_by!(token: token) do |device|
    device.name = name
    device.platform = platform
    device.last_seen_at = last_seen_at
  end
end

northwind = Account.find_or_create_by!(name: "Northwind")
globex = Account.find_or_create_by!(name: "Globex")

dana = seed_user("Dana Whitfield", "dana@example.com")
marcus = seed_user("Marcus Bell", "marcus@example.com")
priya = seed_user("Priya Shah", "priya@example.com")
tom = seed_user("Tom Okafor", "tom@example.com")
lena = seed_user("Lena Ortiz", "lena@example.com")

seed_membership(northwind, dana, :admin)
seed_membership(northwind, marcus)
seed_membership(northwind, priya)

seed_membership(globex, dana, :member)
seed_membership(globex, tom, :admin)
seed_membership(globex, lena)

seed_device(dana, "Dana's iPhone", platform: :ios, token: "apns-6b1f0e2c9d4a4f7e8a3b5c1d2e9f0a7b", last_seen_at: 20.minutes.ago)
seed_device(dana, "Dana's Galaxy Tab", platform: :android, token: "fcm-dW8kq2Lx0RzN5pTe7vYc3bHj", last_seen_at: 2.days.ago)
seed_device(tom, "Tom's Pixel", platform: :android, token: "fcm-tO4mn9Aa1QsK6eWr2zXu8gFi", last_seen_at: 3.hours.ago)
seed_device(marcus, "Marcus's iPhone", platform: :ios, token: "apns-1c7d2e8f3a9b4c0d5e6f7a8b9c0d1e2f", last_seen_at: 1.week.ago)

# Northwind

catalog = seed_project northwind, "Spring catalog",
  creator: dana, assigned: [ dana, priya ],
  description: "Product photography, copy and print layout for the spring catalog."

seed_comments catalog, [
  [ dana, "Photo shoot is booked for the 14th. Priya, can you send the shot list by Monday?" ],
  [ priya, "Shot list is in the shared folder. I left out the patio furniture since it's not in stock until April." ],
  [ dana, "Perfect, thanks." ]
]

website = seed_project northwind, "Website refresh",
  creator: marcus, assigned: [ dana, marcus ],
  description: "New homepage and a simpler pricing page."

seed_comments website, [
  [ marcus, "First pass at the homepage wireframe is up." ],
  [ dana, "Looks good. Let's drop the carousel." ]
]

# Globex

launch = seed_project globex, "Q4 launch",
  creator: tom, assigned: [ dana, tom, lena ],
  description: "Everything that needs to ship for the October release: release notes, pricing changes, support docs and the launch email."

seed_comments launch, [
  [ tom, "Kickoff notes are in the drive. Launch date is locked for the 21st." ],
  [ lena, "Release notes draft is ready for review." ],
  [ tom, "Dana, can you check the pricing table on the release notes?" ],
  [ dana, "On it, will have comments by end of day." ],
  [ dana, "Left a few notes. The enterprise tier still shows last year's price." ],
  [ lena, "Fixed, thanks for catching that." ],
  [ tom, "Support docs are 80% done. Need screenshots for the new settings page." ],
  [ lena, "I can grab screenshots tomorrow morning once staging is updated." ],
  [ tom, "Staging is updated." ],
  [ lena, "Screenshots uploaded." ],
  [ dana, "Launch email copy is in the doc. Tom, does marketing need to sign off?" ],
  [ tom, "Yes, sending it over to them now." ],
  [ tom, "Marketing approved with two small edits." ]
]

billing = seed_project globex, "Billing migration",
  creator: lena, assigned: [ dana, lena, tom ],
  description: "Move invoicing off the legacy system and onto the new billing provider."

seed_comments billing, [
  [ lena, "Export from the old system finished overnight, about 14k invoices." ],
  [ tom, "Any failures?" ],
  [ lena, "12 invoices with missing tax IDs. Listing them in the sheet." ],
  [ dana, "I'll chase down the tax IDs with finance." ],
  [ dana, "Finance sent 9 of the 12. The other 3 are closed accounts." ],
  [ lena, "We can skip the closed ones. Starting the import into the sandbox." ],
  [ tom, "Sandbox import looks clean. Totals match to the cent." ],
  [ lena, "Scheduling the production import for Saturday." ],
  [ dana, "I'll be around Saturday morning if anything comes up." ],
  [ tom, "Import done. Spot-checked 50 invoices, all good." ]
]

portal = seed_project globex, "Customer portal",
  creator: tom, assigned: [ dana, tom, lena ],
  description: "Self-serve portal so customers can download invoices and update payment details."

seed_comments portal, [
  [ tom, "Design review is Thursday at 2." ],
  [ lena, "I added the invoice list mockups to the board." ],
  [ dana, "Do we need SSO for the first version?" ],
  [ tom, "No, email and password is fine to start." ],
  [ lena, "Payment details form is wired up against the sandbox." ],
  [ dana, "Tested on my phone, the card field is cut off on small screens." ],
  [ lena, "Good catch, fixed." ],
  [ tom, "Can we get this in front of two or three customers next week?" ],
  [ dana, "I'll reach out to Acme and Initech." ]
]

intranet = seed_project globex, "Old intranet",
  creator: tom, assigned: [ dana, tom ],
  description: "Wind down the old intranet and move the useful pages to the wiki."

seed_comments intranet, [
  [ tom, "Pages worth keeping are tagged in the spreadsheet." ],
  [ dana, "Moved everything tagged. Redirects are in place." ],
  [ tom, "Thanks. Turning the old server off on Friday." ]
]

intranet.update!(archived_at: 10.days.ago) unless intranet.archived?
