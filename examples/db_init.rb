tim = Candidate.create(name: "tim")
steve = Recruiter.create(name: "steve")
wooga = Company.create(name: "wooga")
steve.company = wooga

tim = Candidate.where(name: "tim").first
steve = Recruiter.where(name: "steve").first