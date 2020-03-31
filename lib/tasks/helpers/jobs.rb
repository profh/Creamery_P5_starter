module Populator
  module Jobs

    def create_jobs
      jobs = %w[Cashier Mopping Make\ ice\ cream Garbage\ removal Wipe\ tables]
      jobs.each do |j|
        job = Job.new
        job.name = j
        job.description = "Best job ever"
        job.active = true
        job.save!
      end
    end
    
  end
end