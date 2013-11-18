#!/usr/bin/env ruby

file = "/root/.ssh/authorized_keys"
lines = []
lines << "## This file auto generated using cron. DO NOT EDIT!!"

unless ENV['AUTHORIZED_KEYS_FILE'].nil?
	file = ENV['AUTHORIZED_KEYS_FILE']
end

File.open(file).each do |line|
	if line.index("#").nil?
		key = %x[ tmp=`tempfile`; echo "#{line}" > $tmp; ssh-keygen -lf $tmp | cut -d" " -f2; rm $tmp; ]
		key.chomp!
		name = line.split.last.split("+")[0].split(".").map{ |w| w.capitalize }.join(" ")
		email = line.split.last.split("+")[0] + "@cyso.nl"
		lines << "#{key}|#{name}|#{email}"
	end  
end

File.open("/etc/gitusers", "w") do |file|
	file.write(lines.join("\n"))
end
