-- making unique_titles table
SELECT DISTINCT ON (emp_no)
	emp_no,
	first_name,
	last_name,
	title
-- INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- making retirement_titles table
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
INTO retirement_titles
FROM employees AS e
RIGHT JOIN titles ON (e.emp_no = titles.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no, e.last_name DESC;

-- making a retiring_titles table
SELECT COUNT(title), title
-- INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- creating mentorship_eligibility table
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	titles.title
-- INTO mentorship_eligibility
FROM employees AS e
	LEFT JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
	LEFT JOIN titles ON (e.emp_no = titles.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no ASC;
	
-- making table to find roles need to be filled
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
INTO active_retirement_titles
FROM employees AS e
RIGHT JOIN titles ON (e.emp_no = titles.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (titles.to_date = '9999-01-01')
ORDER BY e.emp_no, e.last_name DESC;

-- making active_unique_titles table
SELECT DISTINCT ON (emp_no)
	emp_no,
	first_name,
	last_name,
	title
INTO active_unique_titles
FROM active_retirement_titles
ORDER BY emp_no, to_date DESC;

-- making active_retiring_titles table
SELECT COUNT(title), title
-- INTO active_retiring_titles
FROM active_unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- finding total number of potential retirees
SELECT COUNT(title)
FROM active_unique_titles;

-- finding number of mentors born 1965
SELECT COUNT(emp_no)
FROM mentorship_eligibility;

-- creating extended_mentorship_eligibility to include those born from 1952-1965 to be mentors
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	titles.title
INTO extended_mentorship_eligibility
FROM employees AS e
	LEFT JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
	LEFT JOIN titles ON (e.emp_no = titles.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no ASC;

-- finding number of mentors born 1952-1965
SELECT COUNT(emp_no)
FROM extended_mentorship_eligibility;